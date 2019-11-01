FROM devpi_base:latest

# Copy static files (path changes with python version)
RUN cp -R /usr/lib/python3.*/site-packages/devpi_web/templates /devpi/templates && \
    cp -R /usr/lib/python3.*/site-packages/devpi_web/static /devpi/static && \
    chown -R devpi /devpi

# Change to unprivileged user
USER devpi
ENV MASTER_URL=http://localhost:6970
ENV REP_SERVERDIR=/devpi/replicaserver
ENV REP_PORT=4041
EXPOSE 6971:${REP_PORT}

# Inculde git version in web-interface (from docker compose)
ARG GIT_VERSION=unknown
ARG PROJECT_NAME=unknown
ARG PROJECT_URL=unknown
ARG BUILD_DATE=unknown
RUN sed -i -E \
    's~(<li tal:repeat="vi version_infos">\$\{vi\[0\]\}-\$\{vi\[1\]\}</li>)~<li><a href="'${PROJECT_URL}'">'${PROJECT_NAME}'-'${GIT_VERSION}'</a> ('"${BUILD_DATE}"')</li>\n        \1~' \
    /devpi/templates/macros.pt

RUN  env; \
     devpi-server --init --role replica --master-url ${MASTER_URL}  --host 0.0.0.0 --port ${REP_PORT} --theme /devpi/ --serverdir ${REP_SERVERDIR} 2>&1

# Entry point

CMD ["sh", "-c", "exec 2>&1 devpi-server --role replica --master-url ${MASTER_URL} --host 0.0.0.0 --port ${REP_PORT} --theme /devpi/ --serverdir ${REP_SERVERDIR}"]
