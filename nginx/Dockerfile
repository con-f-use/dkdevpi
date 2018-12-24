FROM alpine:3.8

# Outward facing port (overwritten by ../docker-compose.yml)
ARG OUTER_PORT=8080

# Install and configure nginx
RUN apk add --update nginx=1.14.2-r0 sed=4.4-r2
COPY ["nginx.conf", "/etc/nginx/"]
RUN sed -Ei 's~(proxy_set_header X-outside-url \$scheme://\$host:)PORT(;)~\1'$OUTER_PORT'\2~' /etc/nginx/nginx.conf && \
    /bin/chown -R nginx /var/lib/nginx && \
    /bin/chown -R nginx /var/log/nginx

# Start Nginx as unprivileged user
USER nginx
EXPOSE ${OUTER_PORT}:8080
CMD ["nginx"]
