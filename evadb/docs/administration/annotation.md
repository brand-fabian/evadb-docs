# Variant Annotation

To upload a vcf file, first it must be annotated using a custom perl pipeline.

!!! warning "Docker"
    The following documentation is specific to the Docker version of EVAdb.
    When using the bare-metal installation your mileage may vary, the general
    steps remain the same however.

???- note "VEP"
    It is intended to switch from the custom annotation pipeline
    to [VEP](http://grch37.ensembl.org/info/docs/tools/vep/index.html). This documentation will be update accordingly. 

Annotation is performed at the same time as the actual data upload. For this,
we use a set of intermittent annotation and insert steps. Each step performs
annotation for things like genes and transcripts based on data from the
annotation tables present in the database. For ease of use, the annotation
container uses the main script `externalPipelineImport.pl` as entrypoint
interface. To start the import process, the script needs access to a vcf file,
the sample id of the sample in the database and the settings name
(`hg19_plus`).

!!! warning "References with/without chr tags"
    Depending on the Reference that you use for variant calling and alignment,
    the contigs will be either have the `chr` prefix (e.g. `chr1`), or not
    (e.g. `1`). EVAdb uses the UCSC versions of all contigs, so the prefix
    **must** be present.

!!! warning "Data Paths"
    The paths to your data most likely differ between the container and the
    outside world. Make sure to adjust the paths for your mountpoint (
    the `DATA_DIR` configuration variable). Data is mounted to `/data`
    inside the container.

To import a single or multi-sample vcf file, the following command line is
sufficient.

``` bash
docker-compose run annotation -vcf <VCF_FILE> \
  -sample "<SAMPLE>" \
  -se hg19_plus
```

???- note "Inside the container"
    If you want to open a shell inside the annotation container first, the
    command can be run as:

    ``` bash
    docker-compose run annotation bash # or the corresponding docker exec
    perl /pipeline/externalPipelineImport.pl -vcf <VCF_FILE> \
      -sample "<SAMPLE>" \
      -se hg19_plus
    ```

The `externalPipelineImport.pl` draws most of its runtime information off the
`current.config.xml` file. If you are running via docker, all necessary
configuration parameters are set by the `src/make_annotation.sh` script.
If you do run on bare-metal make sure to set the paths in this file such
that tool directories and data locations are what is required by the tool.

## Data Locality

With the current iteration of EVAdb and the Docker images all data must be
local to the EVAdb server. As noticed in the
[configuration part](../installation/docker/configuration.md), all data
directories are entered as docker volume and put through to the container.
As such, the data paths differ between container and host. Nevertheless, it
is not currently possible to upload samples or data from remote hosts to
the machine in excess of what is possible through the use of the web interface.

We recommend a data partition or disk with enough storage for your NGS
experiments to host this data. This brings two advantages, first you spare
the database disk from additional stress (it will be under heavy load on sample
import) and additionally you can use cheaper mass storage media to host the 
bulk (e.g. `.bam` or `.fq.gz`) of your data.

## Post-Import

After variants have been imported into the database they can be queried using
the standard search tools (e.g. autosomal dominant, autosomal recessive).
However, a big part of the filtering capability is derived from in-house
frequencies built into the database. Since the system does not compute these
frequencies after every import, this has to be done manually.

To update variant frequencies in the database, i.e. count the number of
occurences of a snp per disease group, use the following snippet.

``` bash
# Execute from project root
# Drop to the annotation container
docker-compose run annotation bash
# Perform counting of snv and inserting into the proper tables
/pipeline/doAfterImport.pl -se hg19_plus -s 40
```

!!! hint "Post Import init-Container"
    In principle, the process above can also be started from the
    init-Container. If you intend to do so, make sure to modify the
    `config.xml` file accordingly.

## Scripts

### importVCF.sh

To upload many samples in quick succession, we use the following script.

!!! error "Breakage - Adjust before use"
    This script is provided as an example for a complete import process. As it
    is written with the specific configuration of our site in mind it will most
    likely not work without changes on other systems.

``` bash
--8<-- "files/importVCF.sh"
```