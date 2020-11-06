# Administration Guide - Quick Start

!!! tldr "Quick-Start"
    From running instance to first filter query, the following steps need to
    be taken in-order:

    * Create a cooperation
    * Create a project
    * Create necessary diseases
    * Create a sample sheet
    * Upload the sample sheet
    * Annotate and upload your vcf files
    * Filter `Autosomal (dominant|recessive)` or `de-novo`

Once you started the application and have confirmed that it is in working order,
you can start to administer your system. This includes setting up users and
uploading a first dataset to filter for disease causing variants.

All of the following steps are described in greater detail in the different
parts of this section. For the impatient, to be able to filter your first case,
these are the minimal steps you need to do.

???- hint "Evaluation"
    As there are many moving parts within EVAdb, especially around the
    annotation side of the application it is good practice to first upload a
    known solved case to test variant filtration and annotation.

!!! note "Access"
    To follow this guide you need SSH access to the host running EVAdb and
    admin access to both applications (user and admin).

## Create a Cooperation and Project

Prior to uploading samples, we need to setup the support structure. Goto
`New cooperation` and enter your cooperation details in the form. Typically,
this will be your name and details. Afterwards create a project and assign your
new cooperation to the project.

We assume your cooperation is named `Mustermann` and the project is called
`EXOME_CASES`.

## Create diseases

For the sample upload and filter processes to work, we need to create some
diseases. These tables are not pre-populated. Assuming you start with a single
cohort of trio-samples it is advisable to set the parents to a different
disease group than the index cases. Create at least two diseases, one "real"
disease that can be attributed to one of the disease groups and one for the
control samples that you assign the disease group `Controls`.

A simple, yet unspecific example could be two diseases:

1. `Developmental disorder`, `DEV` (group: `Developmental disorder`) and
2. `Controls`, `CTRLS` (group: `Controls`)

## Setup a sample sheet

The sample sheet is the most convenient way to define multiple sample objects
at once. While it is possible to create samples manually or via the LIMS system,
we recommend using sample sheets as source of truth. Every row in the sample
sheet defines exactly one sample and all its relevant attributes. Most of the
columns are mandatory. Upload your sample sheet by using the
`Import external samples` form.

``` CSV
--8<-- "files/example.evadb.csv"
```

The three ID columns `Sample ID`, `Foreign ID` and `Pedigree` are used to
identify samples. Additionally, since `Pedigree` is used as family id, when
the same `Pedigree` is set for multiple samples, we will be able to define the
family structure through the web user interface. To be able to use de-novo
filter and the like it is necessary to specify the family structure by
modifying the generated sample entries.

!!! tip "Disease"
    Make sure to set `Disease` column to the values you used in the previous
    steps.

## Annotate and Upload your variants

!!! danger "Docker"
    The following part is specific to the docker version of EVAdb. When using a
    bare-metal or other installation please adjust the commands.

After defining samples and the family structure for your cohort, the next step
is uploading the variants. The minimum prerequisite other than the previous
step is that all data is local to the server that hosts the mariadb container.

!!! hint "Database"
    Make sure the database is running and able to handle connections using the
    `MYSQL_USER` username prior to starting the annotation container.

To make your data available inside the container, set `DATA_DIR` in your `.env`
file to the directory containing all vcf files that you wish to upload. If you
wish to annotate and insert a specific `.vcf` file, use the following
procedure. We assume that the vcf file is located at
`/share/data/exomes/C1234.vcf.gz` and `DATA_DIR=/share/data`. Then, we can use
the following command to upload the variants. This annotation procedure does
support uploading multi-sample vcf files.

???- warning "chr Tags"
    EVAdb expects all contigs to have the `chr` Prefix. Make sure your contigs
    are named `chr1-chrY` prior to executing this command.

    A simple command to change contig names would be the following (although
    there are some caveats when changing the reference like that). Set `$f` to
    your `.vcf.gz` input and `$VCF` to the desired output location.

    ``` bash
    zcat $f | awk '{ if ( $1 ~ "#" ) { print $0 } else { print "chr"$0 } }' > $VCF
    ``` 

``` bash
docker-compose run annotation -vcf /data/exomes/C1234.vcf.gz \
  -sample C1234 \
  -se hg19_plus
```

Depending on the speed of your system the upload of one sample should be done
in less than ten minutes. Afterwards you can try to filter your variant dataset
using the tools in the EVAdb user application frontend.

Finally, fill the frequency tables with information, s.t. variant filters can
work with the in-house data.

``` bash
docker-compose run annotation bash
/pipeline/doAfterImport.pl -se hg19_plus -s 40
```