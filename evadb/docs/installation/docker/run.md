# Starting the Application

After building the application, starting the whole stack is as simple as
running the following command.

???- note "docker-compose File"
    All `docker-compose` based command lines need to be executed from the
    root directory of the application, where the `docker-compose.yml` is
    located. Otherwise you can rely on standard docker commands.

!!! tip "Controlling execution of the init container"
    The behaviour of the init container can be controlled in a fine-grained
    manner by utilizing the different switches exposed as environment
    variables. For a first start, at least `INIT_DB` and `INIT_USER` have to be
    set to `1`. Additionally, we recommend setting `IMPORT_CDSDB` as otherwise
    the import process will not fully function.

    Make sure to unset `INIT_DB` and `INIT_USER` after the init container has
    run once.

``` bash
docker-compose up -d
```

After some time, all containers will be started and isolated and your instance
of EVAdb should be available at
[User Login](https://localhost:443/cgi-bin/login.pl)
and
[Admin Login](https://localhost:8443/cgi-bin/login.pl).
If you are running on a remote server, you have to substitute localhost for
the actual server name.

If there are trouble getting a response from the server, you can use

``` bash
docker-compose logs [-f] [SERVICE_NAME]
```

to inspect the logs of all services (if `SERVICE_NAME` is omitted) or 
specific services (supply the name). For further troubleshooting, it is 
possible to descend into the services using the following commands.

``` bash
docker-compose exec [SERVICE_NAME] [TOOL] # If the service is still running
docker-compose run [SERVICE_NAME] [TOOL] # If the service stopped
```

To inspect the state of your container setup, please use `docker-compose ps`.

!!! note "Container ≠ Service"
    Container obtained from ps are not the same thing as service names used by
    exec/run/logs. Refer to the correct service names in the
    `docker-compose.yml` file.
