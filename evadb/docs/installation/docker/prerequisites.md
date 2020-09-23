# Prerequisites

In order to run the docker version of EVAdb in a secure and performant manner,
some prerequisites need to be fulfilled. Please make sure that you have a basic
understanding of docker and how the web works before setting up this website.

In order to follow setup and usage guides, it is important that you have an
understanding on docker, SSL certificates (for https) and the performance of
the system you are hosting your database at.

## Physical Infrastructure

!!! tldr "Hardware Requirements"
    To be able to host EVAdb, the hardware must have:

      * 4TB NVMe/SSD Storage

    Additional performance improvements are gained by utilizing more RAM
    and CPU Power.

EVAdb is meant to host multiple thousand exome cases. As is the case with such
datasets, even storing only variants will have the database growing to be
multiple terabytes in size. In order to have a nice user experience for the
frontend, it is important that the backend database does not bog down even for
large requests (f.e. all autosomal dominant variants for one sample). To be
able to scale the amount of data, we recommend a physical server utilizing
NVMe (or at least SSD) storage technologies. This will greatly increase the
database performance for all queries. Make sure you have enough storage
available for the expected amount of data. The initialized application will
consume around 400GB without any cases added.

!!! caution "Spinning Rust"
    We advise heavily against running the databse on older HDD type
    storage media. Performance will be abysmal.

## Docker

??? info "Docker"
    Docker is a isolation technique prevalent in modern software development
    since it allows the automatic deployment of complex software stacks.

    Read more: [Docker Get Started](https://docs.docker.com/get-started/)

!!! tldr "Docker Setup"
    To be able to host EVAdb through Docker Images, make sure you have
    installed and correctly configured:

    1. [Docker](https://docs.docker.com/engine/install/)
    2. [docker-compose](https://docs.docker.com/compose/install/)

If you desire to install the application via Docker, please familiarize
yourself with the basic concepts of Docker. To deploy the application, we use
docker-compose which allows us to deploy the stack of multiple containers
through use of a single command.

Please follow the installation instructions for docker on your favorite
operating system over at [docker.com](https://docs.docker.com/engine/install/).
Some operating systems might need additional setup after installation of
docker, typically adding the active user to the `docker` group. Make sure
you follow these steps as well [(postinstallation)](https://docs.docker.com/engine/install/linux-postinstall/).
To be able to continue with the installation guide, please also install
[docker-compose](https://docs.docker.com/compose/install/).