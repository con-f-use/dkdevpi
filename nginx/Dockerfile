FROM alpine:3.10.2

# Outward facing port (overwritten by ../docker-compose.yml)
ARG OUTER_PORT=8080
ARG OUTER_SSL_PORT=8443

# Install and configure nginx
RUN apk add --no-cache --update nginx sed
COPY ["nginx.conf", "/etc/nginx/"]
COPY ["dkdevpi.crt", "dkdevpi.key", "/devpi/"]
RUN sed -Ei 's~(proxy_set_header X-outside-url \$scheme://\$host:)PORT(;)~\1'$OUTER_PORT'\2~' /etc/nginx/nginx.conf && \
    sed -Ei 's~(proxy_set_header X-outside-url \$scheme://\$host:)SSL_PORT(;)~\1'$OUTER_SSL_PORT'\2~' /etc/nginx/nginx.conf && \
    chown -R nginx /var/lib/nginx /var/log/nginx /devpi/dkdevpi.*

# Start Nginx as unprivileged user
USER nginx
EXPOSE ${OUTER_PORT}:8080
EXPOSE ${OUTER_SSL_PORT}:8443
CMD ["nginx"]

# (1/3) Installing pcre (8.43-r0)
# (2/3) Installing nginx (1.16.1-r0)
# Executing nginx-1.16.1-r0.pre-install
# (3/3) Installing sed (4.7-r0)
# Executing busybox-1.30.1-r2.trigger
# OK: 7 MiB in 17 packages

