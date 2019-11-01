FROM alpine:3.10.2

# Disable output stream buffering
ENV PYTHONUNBUFFERED=1
#ENV CHAMELEON_RELOAD=true

RUN adduser -D devpi && \
    mkdir -p /devpi/server /devpi/server-upgrade /usr/local/share/ca-certificates/ && \
    chown -R devpi /devpi

ARG PIP_OPTIONS="--no-cache-dir "
ARG BUILD_DEPS=" \
    gcc=8.3.0-r0 \
    libffi-dev=3.2.1-r6 \
    musl-dev=1.1.22-r3 \
    openssl-dev=1.1.1d-r0 \
    python3-dev=3.7.5-r1 \
    "
ARG DEVPI_PKGS=" \
    devpi-server==5.2.0 \
    devpi-web==4.0.0 \
    devpi-ldap==1.2.2\
    "

# Install devpi
RUN \
    apk update && \
    apk add --no-cache --update python3=3.7.5-r1 ca-certificates && \
    apk add --no-cache --virtual .build-deps ${BUILD_DEPS} && \
    pip3 install ${PIP_OPTIONS} --upgrade pip  && \
    pip3 install ${PIP_OPTIONS} --upgrade cffi && \
    pip3 install ${PIP_OPTIONS} ${DEVPI_PKGS} && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    update-ca-certificates 

# (1/30) Upgrading libcrypto1.1 (1.1.1c-r0 -> 1.1.1d-r0)
# (2/30) Upgrading libssl1.1 (1.1.1c-r0 -> 1.1.1d-r0)
# (3/30) Installing ca-certificates (20190108-r0)
# (4/30) Installing binutils (2.32-r0)
# (5/30) Installing gmp (6.1.2-r1)
# (6/30) Installing isl (0.18-r0)
# (7/30) Installing libgomp (8.3.0-r0)
# (8/30) Installing libatomic (8.3.0-r0)
# (9/30) Installing libgcc (8.3.0-r0)
# (10/30) Installing mpfr3 (3.1.5-r1)
# (11/30) Installing mpc1 (1.1.0-r0)
# (12/30) Installing libstdc++ (8.3.0-r0)
# (13/30) Installing gcc (8.3.0-r0)
# (14/30) Installing linux-headers (4.19.36-r0)
# (15/30) Installing libffi (3.2.1-r6)
# (16/30) Installing pkgconf (1.6.1-r1)
# (17/30) Installing libffi-dev (3.2.1-r6)
# (18/30) Installing musl-dev (1.1.22-r3)
# (19/30) Installing openssl-dev (1.1.1d-r0)
# (20/30) Installing libbz2 (1.0.6-r7)
# (21/30) Installing expat (2.2.8-r0)
# (22/30) Installing gdbm (1.13-r1)
# (23/30) Installing xz-libs (5.2.4-r0)
# (24/30) Installing ncurses-terminfo-base (6.1_p20190518-r0)
# (25/30) Installing ncurses-terminfo (6.1_p20190518-r0)
# (26/30) Installing ncurses-libs (6.1_p20190518-r0)
# (27/30) Installing readline (8.0.0-r0)
# (28/30) Installing sqlite-libs (3.28.0-r0)
# (29/30) Installing python3 (3.7.4-r0)
# (30/30) Installing python3-dev (3.7.4-r0)
# Successfully installed Chameleon-3.6.2 PasteDeploy-2.0.1 PyYAML-5.1.2 Whoosh-2.7.4 apipkg-1.5 appdirs-1.4.3 argon2-cffi-19.1.0 beautifulsoup4-4.8.1 bleach-3.1.0 certifi-2019.9.11 cffi-1.12.3 chardet-3.0.4 cmarkgfm-0.4.2 defusedxml-0.6.0 devpi-common-3.4.0 devpi-ldap-1.2.2 devpi-server-5.1.0 devpi-web-3.5.2 docutils-0.15.2 execnet-1.7.1 hupper-1.8.1 idna-2.8 importlib-metadata-0.23 itsdangerous-1.1.0 ldap3-2.6.1 more-itertools-7.2.0 passlib-1.7.1 pip-19.2.3 plaster-1.0 plaster-pastedeploy-0.7 pluggy-0.13.0 py-1.8.0 pyasn1-0.4.7 pycparser-2.19 pygments-2.4.2 pyramid-1.10.4 pyramid-chameleon-0.3 python-dateutil-2.8.0 readme-renderer-24.0 repoze.lru-0.7 requests-2.22.0 ruamel.yaml-0.16.5 ruamel.yaml.clib-0.2.0 six-1.12.0 soupsieve-1.9.4 strictyaml-1.0.5 translationstring-1.3 urllib3-1.25.6 venusian-1.2.0 waitress-1.3.1 webencodings-0.5.1 webob-1.8.5 zipp-0.6.0 zope.deprecation-4.4.0 zope.interface-4.6.0
