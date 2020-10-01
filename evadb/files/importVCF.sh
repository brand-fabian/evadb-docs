#! /bin/bash
# vim: ts=4 sw=4 expandtab

EVADB_DIR="/home/evadb"
INPUT_DIR="/gluster/gluster01/share/exome"

function usage {
    echo -e "importVCF.sh\n\nImport all VCFs of a given Flow Cell into the EVAdb running in $EVADB_DIR as\ndocker version. Files are searched for in $INPUT_DIR.\n\nParameters:\n\n\t-f\t\tFlow Cell to import.\n\t-h\t\tPrint help."   
}

PW_FILE="/home/evadb/.env"
ROOT_PW=$(grep MYSQL_ROOT_PASSWORD $PW_FILE | cut -d"=" -f2)

while getopts "f:h" arg; do
    case $arg in
        f)
            FLOW_CELL="${OPTARG}"
            ;;
        h)
            usage
            exit 0
            ;;
    esac
done

if [ -z "$FLOW_CELL" ]; then
    echo -e "Error: Please supply a flow cell id."
    usage
    exit 1
fi

echo -e "Searching $INPUT_DIR/$FLOW_CELL/"
ESC_INPUT=$(echo "${INPUT_DIR}" | sed -e 's/[](&|$|\|{|}).*[\^]/\\&/g')

cd $EVADB_DIR
for f in $(find "$INPUT_DIR/$FLOW_CELL/" -name "DE*vcf.gz")
do
    BASENAME=$(basename $f)
    DIRNAME=$(dirname $f)
    SAMPLE=${BASENAME%%.*}
    VCF="$DIRNAME/$SAMPLE.chr.vcf"

    QUERY="select * from sample where name LIKE '%$SAMPLE%' or pedigree LIKE '%$SAMPLE%' or foreignid LIKE '%$SAMPLE%';"
    SAMPLE_IN_DB=$(docker-compose exec db mysql -u root -p$ROOT_PW -e "$QUERY" exomehg19 | grep "$SAMPLE")
    
    if [[ -n "$SAMPLE_IN_DB" ]];
    then
        echo "Annotating and Importing $SAMPLE.."

        echo -e "\tAdding chr prefix..."
        zcat $f | awk '{ if ( $1 ~ "#" ) { print $0 } else { print "chr"$0 } }' > $VCF

        echo -e "\tImporting $SAMPLE into evadb..."
        docker-compose run annotation -vcf "${VCF/$ESC_INPUT/\/data}" -sample "$SAMPLE" -se hg19_plus

        echo -e "\tCleanup..."
        rm $VCF
    else
        echo -e "Could not find $SAMPLE in database. Have you create the sample using \"Import external samples\"?"
    fi
done
cd -