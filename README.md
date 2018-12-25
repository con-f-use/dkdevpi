# QA devpi

Docker-compose setup to run a local Python Package Index (PI).

Runs a [devpi][dp] container behind an [Nginx][nx] instance for maximal modularity.
For a small footprint the base of all the containers is [Alpine][al].

![diagram](docker_devpi.png)

## Running an instance

First thing you will have to decide under which outward facing port
you want your package index to be reachable.
This port is referred to as the `OUTER_PORT` in the docker and
docker-compose files.
You can just change it in `./.env` or live with the
default of 6970 (decimal value of ASCII chars "pi").

After that, run:

```
export GIT_VERSION=$(git rev-parse --abbrev-ref HEAD).$(git describe --always --dirty --abbrev)
export GIT_SHA=$(git rev-parse HEAD)
export BUILD_DATE=$(date --rfc-3339=seconds)
docker-compose build
docker-compose up -d
```

If the `devpidocker-data` container does not already contain
a server configuration, then you'll have to add the `--init`
option to the `devpi-server` call, restart the container,
remove the option again, and restart the container again.

If you used the default port, devpi should be reachable under:
http://localhost:6970/.

**Note:** devpi may display some error messages on the webui.
They should disappear after some minutes, when the database is
initialized.

The same process is used to rebuild and restart the containers
after changes were made. The volumes should not be affected.

## Saving the Server Configuration

You can [export and re-import all devpi data][1] (except for
the cached packages).
Exporting is done by running:

```
export DUMPDIR=dump-$(date +%Y%m%d-%H%M%S)
docker run --rm \
  --volumes-from=dockerdevpi_data_1 \
  -v $(pwd):/dump \
  dockerdevpi_devpi \
  devpi-server --serverdir /devpi/server --export /dump/$DUMPDIR
```
The dumped data is now in a folder called `dump-XXXX` where XXXX
is a timestamp of when the dump was made.

If you want to backup the cached files as well, do something
akin to `docker cp dockerdevpi_data_1:devpi/server/ $DUMPDIR/`

You can import the old server state to a different server
directory or one that you have rebuild:
```
docker-compose stop devpi nginx
docker-compose build   # If you changed the Dockerimage
docker run --rm \
  --volumes-from=dockerdevpi_data_1 \
  -v $(pwd)/$DUMPDIR:/dump \
  dockerdevpi_devpi \
  devpi-server --serverdir /devpi/server-upgrade --import /dump
```
Completion of the import might take a long time depending on the
filesizes.
To test if the import works, start another container
with the new directory:
```
docker run --rm -ti \
    --volumes-from=dockerdevpi_data_1 \
    -p 8080:4040 \
    dockerdevpi_devpi \
    devpi-server --host 0.0.0.0 --port 4040 --serverdir /devpi/server-upgrade
```
If `http://localhost:8080/` looks fine, press `CTRL+C` to stop the test.

Run the `./devpi/upgrade.sh` shellscript insde the new
container and restart the setup.
```
docker run --rm \
    --volumes-from=dockerdevpi_data_1 \
    dockerdevpi_devpi \
    /bin/sh /devpi/upgrade.sh
docker-compose up -d
```
Do not forget to cleanup the leftover containers from the previous steps.
They should have exited.

# License
This is a personal project.
The Author prefers if you ignored it, until it is ready.
All rights reserved for now.


[al]: https://hub.docker.com/_/alpine/
[1]: http://doc.devpi.net/latest/quickstart-server.html#versioning-exporting-and-importing-server-state
[dp]: https://www.devpi.net
[nx]: https://nginx.org
