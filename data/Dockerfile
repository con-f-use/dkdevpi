FROM alpine:3.8

# Disable output stream buffer
ENV PYTHONUNBUFFERED=1

# Create devpi server folders
RUN adduser -D devpi && \
    mkdir -p /devpi/server /devpi/server-upgrade && \
    chown -R devpi:devpi /devpi

# Entry point, simply exit with status code 0
CMD ["/bin/true"]
