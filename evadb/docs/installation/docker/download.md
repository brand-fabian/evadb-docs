# Download

To be able to build and run the software, we first need to download the scripts
and binary files. Additionally to have a fully functioning EVAdb many 
third-party datasets should also be downloaded. Data from [gnomAD](https://gnomad.broadinstitute.org),
 [dbSNP](https://www.ncbi.nlm.nih.gov/snp/) and others is used in many
filtering steps to find rare variants or variants associated with the given
phenotype of the patient. After downloading the scripts and Dockerfiles, we
will build the container images.

???- question "Are pre-built Docker containers available for EVAdb?"
    Currently, the Docker containers for EVAdb are not available on a public
    docker registry. Therefore, the images must be built on a local machine
    before use.


## EVAdb

All files necessary to deploy EVAdb can be found in the git repository of EVAdb
([here](https://github.com/mri-ihg/EVAdb)). The `docker` branch contains
Dockerfiles and docker-compose scripts for building and installing the software.

??? hint "Proxy"
    If youre locked behind a restrictive proxy that you need to access the
    internet from your build host you have to adapt the Dockerfiles. Currently,
    it is necessary to set the `http_proxy` and `https_proxy` environment
    variables.

    ``` bash
    # Prefix each Dockerfile with
    ENV http_proxy http://<USER>:<PW>@<IP>:<PORT>/
    ENV https_proxy http://<USER>:<PW>@<IP>:<PORT>/

    RUN git config --global https.proxy ${https_proxy} \
      && git config --global http.proxy ${http_proxy} \
      && git config --global https.proxyAuthMethod basic \
      && git config --global http.proxyAuthMethod basic
    ```

To clone the EVAdb docker branch, use

``` bash
git clone -b docker https://github.com/mri-ihg/EVAdb.git
```

## Third-Party Data

When building the container images and on first startup of the application, it
is recommended to have some third party datasets available. It is possible to
run the application without this data for development purposes, but in a
production setup these datasets should be present in order for all features to
work as expected (f.e. gnomAD filtering).

!!! caution "hg19 vs GRCh38"
    All library file URL's have to be adjusted for `hg38`

    If you intend to process `hg38` with the current version of EVAdb, make
    sure to include the correct library files. All URL's in the table below are for `hg19`.

???- hint "Dataset Storage"
    Some of the datasets are very large. gnomAD genomes for example exceeds
    200GB in size. Make sure to have enough disk space available when
    downloading these assets.

| Dataset | Description | URL |
| :---: | :---: | :---: |
| dbNSFP | Polyphen2 and SIFT scores are taken from dbNSFP | ftp://dbnsfp:dbnsfp@dbnsfp.softgenetics.com/dbNSFPv3.5a.zip |
| CADD | Cadd scores | https://krishna.gs.washington.edu/download/CADD/v1.6/GRCh37/whole_genome_SNVs.tsv.gz |
| gnomAD | Genome aggregation database Exome and Genome builds | https://storage.googleapis.com/gnomad-public/release/2.1.1/vcf/exomes/gnomad.exomes.r2.1.1.sites.vcf.bgz |
| | | https://storage.googleapis.com/gnomad-public/release/2.1.1/vcf/genomes/gnomad.genomes.r2.1.1.sites.vcf.bgz |
| OMIM | Mendelian inheritance in men | Request individual acces at [omim.org](https://www.omim.org/downloads) |