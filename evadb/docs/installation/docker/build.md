## Docker Container

!!! tldr "Docker Container"
    The application, as presented, utilizes multiple docker containers for the
    components.

    * mariadb
    * EVAdb (docker/snv-hg19p)
    * EVAdb admin (docker/snvedit)
    * init container (helperscripts)
    * annotation (annotation)

The EVAdb application consists of two user-facing web interfaces hosted through
an Apache Webserver as cgi scripts. To run the application, we also setup the
mysql database (mariadb), an init container and an annotation container. The
primary use-case of the init container is creation of the database, initial
user setup and import of external databases. It should be run on first startup
and whenever external data needs changing. The annotation container is intended
to be used for the import of vcf files from your standard GATK best practices
pipeline.

The setup of all containers is done through the docker-compose script 
(`docker-compose.yml`). Below, we will explain the basic setup of each 
containers.

!!! hint "docker-compose run"
    To execute a tool in a running container of our setup, please use either

    ``` bash
    docker-compose exec [db|evadb_user|evadb_admin|evadb_init|annotation] bash
    ```

    if the container is currently running, or

    ``` bash
    docker-compose run [db|evadb_user|evadb_admin|evadb_init|annotation] bash
    ```

    if the container is currently shut off. For example, to inspect the
    database in detail, one can use

    ``` bash
    docker-compose exec db mysql -u <USER> -p<PW>
    ```

    to get a mysql shell in the container.

### EVAdb and EVAdb Admin Containers

Both containers are extended from standard apache/httpd Dockerfiles. We support
some environment variables to supply the database user and password data. For
each container, the application will run as https web service on port 443 which
can be forwarded by standard docker syntax. By default, the user facing filter
application will take port 443 of the host and the admin application will use
port 8443.

???- hint "Firewall Setup"
    When running a production setup where access to your EVAdb instance from
    the internet is required it is recommended to run a firewall with _only_
    port 443 accessible from the outside. In such a setup, you could access
    the admin backend only from your local network or through SSH
    port-forwarding (f.e.)

!!! danger "SSL Setup"
    Both containers require a docker volume to be mounted at the `/ssl`
    location (can be read-only) containing a certificate and private key file
    for the SSL connection. The files **must** be named `evadb.crt` and
    `evadb.key` respectively.

### Init Container

The init container will initialize the database. It creates the first user for
the web interface which can then create other users as well. It is built from
a standard debian image and installs most software for running the perl scripts
to setup the database.

!!! hint "First Startup"
    On first start, the EVAdb will typically launch against an unitialized
    database. In order to function properly, at least `INIT_DB` and `INIT_USER`
    have to be set to `1` to create the database setup and add initial
    user credentials.

It features two docker-volumes which need to be populated with data for the
container to work properly.

| Volume | Purpose |
| :--- | :--- |
| `/library` | Hosting pre-downloaded external databases (gnomAD, dbNSFP etc.). See the [Download Section](https://brand-fabian.github.io/evadb-docs/installation/docker/download/) for more details.  |
| `/database` | Database dumps and sql scripts for database creation. The container uses all scripts from this folder to initialize the database. |

The behaviour of the container can be influenced by setting the `IMPORT_*` and
`INIT_*` environment variables. This is especially useful if only a single 
third-party dataset should be reimported. Other values than `1` (e.g. `0`) will
turn off the respective part.

!!! danger "Database Wipe"
    If the Init container is run with `INIT_DB=1` on an initialized database
    all data is wiped off the installation.

| Setting | Default | Description |
| :--- | :---: | :--- |
| INIT_DB | 1 | Initialize the database (**wipes existing data**)  |
| INIT_USER | 1 | Setup admin user and password |
| IMPORT_DBNSFP | 1 | Toggle import of Polyphen2 and SIFT |
| IMPORT_CADD | 1 | Toggle import of CADD scores |
| IMPORT_GNOMAD | 1 | Toggle import of gnomAD |
| IMPORT_DGV | 1 | Toggle import of dgv structural variation |
| IMPORT_CLINVAR | 1 | Toggle import of clinvar data |
| IMPORT_UCSC | 1 | Toggle import of ucsc data |
| IMPORT_CDSDB | 1 | Toggle import of coding sequence database |
| IMPORT_LOF_METRICS | 1 | Toggle import of gnomad scores by gene |

### Annotation Container

The annotation container is built from the [ngs-pipeline](https://github.com/mri-ihg/ngs_pipeline.git)
repository. Its primary purpose is enabling the import of vcf files for samples.
For this, it uses the `externalPipelineImport.pl` tool as its main interface via
`entrypoint.sh`. Data should be provided via the volume `/data`. The container
expects library data (such as human reference genomes) at `/library` and
databases for annotation at `/anno_db`.

How to use this container to import a VCF file will be described in another section.

## Build

Before the application can be started, application containers have to be built.
This can be achieved with the following command.

``` bash
docker-compose build
```

!!! note "Time"
    Building these containers will take some time. Especially the init and
    annotation containers have to install a lot of perl modules and take some
    time before they are ready.