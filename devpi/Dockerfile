FROM alpine:3.8

# Disable output stream buffering
ENV PYTHONUNBUFFERED=1

# Install devpi
RUN apk add --update python3=3.6.6-r0
RUN apk add --no-cache --virtual .build-deps gcc=6.4.0-r9 libffi-dev=3.2.1-r4 musl-dev=1.1.19-r10 openssl-dev=1.0.2q-r0 python3-dev=3.6.6-r0 && \
    pip3 install \
        "devpi-server>=4.8.0,<4.9" \
        "devpi-web>=3.5.0,<3.6" \
        "devpi-client>=4.2.0,<4.3" && \
    apk del .build-deps gcc libffi-dev musl-dev openssl-dev python3-dev

# devpi-ldap
# devpi-builder

# Create devpi user
RUN adduser -D devpi \
    && mkdir /devpi \
    && chown -R devpi:devpi /devpi

# Copy static files (pash changes with python version)
RUN cp -R /usr/lib/python3.*/site-packages/devpi_web/static /devpi/+static

# Add upgrade script
COPY upgrade.sh /devpi/

# Expose volume
VOLUME ["/devpi/server"]

# Change to unprivileged user
USER devpi
COPY run.sh /devpi/

# Entry point
EXPOSE 4040
CMD ["/bin/sh", "/devpi/run.sh"]
