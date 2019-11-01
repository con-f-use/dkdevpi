#!/bin/bash

for fl in .env; do
if [ -r "$fl" ]; then
    source "$fl"
else
    1>&2 echo "Error: No '$fl' file found. You may want to create it from 'template_$fl'"
    exit 1
fi
done

export BASE_IMAGE_NAME=devpi_base
if [ ! -z "$LDAP_SEARCH_PASSWORD" ]; then
    export LDAP_SEARCH_PASSWORD
fi

# Automatically generated
export GIT_VERSION=$(git rev-parse --abbrev-ref HEAD).$(git describe --always --dirty --abbrev)
export GIT_SHA=$(git rev-parse HEAD)
export BUILD_DATE=$(date --rfc-3339=seconds)
export DOCKER_VERSION=$(docker --version)

build_base() {
    docker build \
        --tag "$BASE_IMAGE_NAME" \
        --tag "$DOCKER_REGISTRY${DOCKER_REGISTRY:+/}$BASE_IMAGE_NAME:latest" \
        --label "org.label-schema.schema-version=1.0" \
        --label "maintainer=$MAINTAINER" \
        --label "org.label-schema.name=$PROJECT_NAME" \
        --label "org.label-schema.description=Parent image for devpi master server and replicas" \
        --label "org.label-schema.vcs-ref=$GIT_SHA" \
        --label "org.label-schema.version=${GIT_VERSION:-unknown}" \
        --label "org.label-schema.vcs-url=$PROJECT_URL/?at=$GIT_SHA" \
        --label "org.label-schema.vendor=$ORGANIZATION" \
        --label "org.label-schema.build-date=$BUILD_DATE" \
        "$@" base/
    if [ "${1:-noupload}" == "upload" ]; then
        registry_name="$DOCKER_REGISTRY${DOCKER_REGISTRY:+/}$BASE_IMAGE_NAME:$(date +%Y%m%d-%Z%H%M%S)-${GIT_VERSION}"
        docker tag "$BASE_IMAGE_NAME" "$registry_name" &&
            docker push "$registry_name"
        #docker tag "$BASE_IMAGE_NAME" "$DOCKER_REGISTRY/$BASE_IMAGE_NAME:latest" &&
        docker push "$DOCKER_REGISTRY${DOCKER_REGISTRY:+/}$BASE_IMAGE_NAME:latest"
    fi
}

upload_images() {
    tstamp=$(date +%Y%m%d-%Z%H%M%S)
    for img in ${PROJECT_NAME}_{nginx,areplica,devpi}; do
        registry_name="$DOCKER_REGISTRY${DOCKER_REGISTRY:+/}$img:$tstamp-${GIT_VERSION}"
        docker tag "$img" "$registry_name" &&
            docker push "$registry_name"
        docker tag "$img" "$DOCKER_REGISTRY${DOCKER_REGISTRY:+/}$img:latest" &&
            docker push "$DOCKER_REGISTRY${DOCKER_REGISTRY:+/}$img:latest"
    done
}

backup() {
    export DUMPDIR=dump-$(date +%Y%m%d-%H%M%S)
    devpidir="${HOME:-/root}/devel/cuda/cudadevpi"
    #devpidir="/root/devel/cudadevpi"
    docker run --user root --volumes-from=${PROJECT_NAME}_devpi_1 -v $devpidir:/dump ${PROJECT_NAME}_devpi devpi-server --serverdir /devpi/server --export /dump/$DUMPDIR
    tar czfv "$devpidir/$(hostname)-$DUMPDIR.tgz" $devpidir/$DUMPDIR
    sshpass -p "${BACKUP_PW}" scp "$devpidir/$(hostname)-$DUMPDIR.tgz" "${BACKUP_LOCATION}" &&
        rm -rf $devpidir/${DUMPDIR} "$devpidir/$(hostname)-$DUMPDIR.tgz"
}

restore_backup() {
    if [ "$1" != "-y" ]; then
    1>&2 echo -e "DANGER! This may overwrite your data! You might  want to make a backup.\n" \
                 "Run again with -y option as first argument that is okay!"
    exit 1
    fi
    dumplocation="${2:?Need to provide a dump location to restore from}"
    [ ! -d "$dumlocation" ] && { 1>&2 echo "Not a directory: $dumplocation"; exit 1; }
    docker-compose stop devpi
    docker-run --user root --volumes-from=${PROJECT_NAME}_devpi_1 -v "$dumplocation:/dump" ${PROJECT_NAME}_devpi_devpi devpi-server --serverdir /devpi/server-upgrade --import /dump
    echo "Now start a new instance of the ${PROJECT_NAME}_devpi container with '--serverdir /devpi/server_upgrade' and test it."
    echo "If you are happy, you might run '/devpi/upgrade.sh' in the new container and restart the setup 'docker-compose up -d'."
}

cleanall() {
    if [ "$1" != "-y" ]; then
    1>&2 echo -e "DANGER! Removes all trances of ${PROJECT_NAME}" \
                 "and ALL unused images and containers!\n" \
                 "Run again with -y option as first argument that is okay!"
    exit 1
    fi
    docker-compose down
    docker ps --filter status=exited -q | xargs docker rm --volumes
    docker images --filter dangling=true -q | xargs docker rmi
    docker rmi -f ${PROJECT_NAME}_{devpi,nginx,areplica}
    docker volume rm -f ${PROJECT_NAME}_server ${PROJECT_NAME}_server-upgrade
}

build_images() {
    build_base
    docker-compose build "$@"
}

if [ "$0" = "$BASH_SOURCE" ]; then
    subcmd=${1:?Expecting sub-command as first argument!}
    shift
    case "$subcmd" in
        backup)
            backup "$@"
            exit 0
        ;;
        restore)
            restore_backup "$@"
        ;;
        base)
            build_base "$@"
        ;;
        build)
            build_images "$@"
        ;;
        run)
            docker-compose stop nginx devpi || true
            build_images "$@" &&
            docker-compose up -d
            {
                sleep 5
                docker ps -a --format 'table {{.Image}}\t{{.Command}}\t{{.Names}}\t{{.Status}}'
                echo
            } &
        ;;
        clean)
            cleanall "$@"
        ;;
        *)
            1>&2 echo "Error: Unknown command $subcmd"
            exit 1
        ;;
    esac
fi
