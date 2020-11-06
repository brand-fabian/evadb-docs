# Configuration

The original software of EVAdb is not very configurable and does not feature
any dedicated configuration files. Therefore, the options for configuration
are very limited. Nevertheless **all** of the following parameters should be
set in your docker `.env` file prior to build time. The `.env` should be located
in the project root, where the `docker-compose` commands will be executed.

???- "Docker `.env`"
    Make sure you understand the basics behind docker environment variables
    and how the `.env` file fits in.

    Read more: [Environment variables in Compose](https://docs.docker.com/compose/environment-variables/)

The following parameters are available to be configured. Please also see the
example file at the end of this section.

| Setting | Description | Example |
| :--- | :--- | :--- |
| MYSQL_ROOT_PASSWORD | Password of the mysql root user | sup3rs3cur3 |
| MYSQL_PASSWORD | Password for the mysql user | myPass |
| MYSQL_USER | Username for the mysql account | evadb |
| MYSQL_DATABASE | Standard mysql database | solexa |
| YUBIKEY_ID | Yubikey ID (if present) | test |
| YUBIKEY_APIKEY | Yubikey api key | secr3t |
| DATABASE_DIR | Persistent database storage dir | /big_storage |
| CURRENT_UID | UID and GID to run the database with normal user permissions | 1000:1000 |
| CERT_DIR | Directory where certificates are stored | /secrets |
| INITIAL_USER | Initial evadb user name | admin |
| INITIAL_USER_PASSWD | Password for the initial evadb user | abc123 |
| ANNO_DB_DIR | Location of annotation databases (gnomAD, dbNSFP etc.) | /anno_db |
| LIBRARY | Location for library files (reference genomes etc.) | /reference |
| DATA_DIR | Directory containing data files for upload (vcf etc.) | /data |

## Example .env File

???- hint "Setting CURRENT_UID"
    To set the `CURRENT_UID` parameter for your own user, use the result of the command:

    ``` bash
    echo "$(id -u):$(id -g)"
    ```

The following is an example `.env` file. Place it in the project root directory.

``` bash
MYSQL_ROOT_PASSWORD=root_pw
MYSQL_PASSWORD=user_pass
MYSQL_USER=evadb
MYSQL_DATABASE=solexa
YUBIKEY_ID=test
YUBIKEY_APIKEY=secr3t
DATABASE_DIR=/evadb
CURRENT_UID=1000:1000
CERT_DIR=/home/evadb/secrets/
INITIAL_USER=admin
INITIAL_USER_PASSWD=admin_pw
ANNO_DB_DIR=/annotation_db/
LIBRARY=/library/
DATA_DIR=/data/
```
