# Starting the Application

After building the application, starting the whole stack is as simple as
running the following command.

!!! note "docker-compose File"
    All `docker-compose` based command lines need to be executed from the
    root directory of the application, where the `docker-compose.yml` is
    located. Otherwise you can rely on standard docker commands.

``` bash
docker-compose up -d
```

After some time, all containers will be started and isolated and your instance
of EVAdb should be available at
[https://localhost:443/cgi-bin/login.pl](https://localhost:443) 
and
[https://localhost:8443/cgi-bin/login.pl](https://localhost:8443).
If you are running on a remote server, you have to substitute localhost for
the actual server name.

If there are trouble getting a response from the server, you can use

``` bash
docker-compose logs [-f] [CONTAINER_NAME]
```

to inspect the logs of all containers (if `CONTAINER_NAME` is omitted) or 
specific containers (supply the name). For further troubleshooting, it is 
possible to descend into the containers using the following commands.

``` bash
docker-compose exec [CONTAINER_NAME] [TOOL] # If the container is still running
docker-compose run [CONTAINER_NAME] [TOOL] # If the container stopped
```

To inspect the state of your container setup, please use `docker-compose ps`.