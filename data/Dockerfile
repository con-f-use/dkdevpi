FROM alpine:3.8
LABEL maintainer Jan Christoph Bischko <jbischko@barracuda.com>
# This is mostly a convenience container for dabpi server
# data access. It might not be needed when modernizing the
# compose file.

# Disable output stream buffer
ENV PYTHONUNBUFFERED=1

# Create devpi server folders
RUN adduser -D devpi && \
    mkdir -p /devpi/server /devpi/server-upgrade && \
    chown -R devpi:devpi /devpi

# Entry point, simply exit with status code 0
CMD ["/bin/true"]

