FROM devpi_base:latest

# Scripts and necessary data
RUN  mkdir /devpi/devpi_semantic_ui/
COPY . /devpi/

# Copy static files (path changes with python version)
RUN ln -s /devpi/static /devpi/+static && \
    ls /devpi/ && \
    chown -R devpi /devpi && \
    chmod ug+x /devpi/*.sh
# For regular theme:
#RUN cp -R /usr/lib/python3.*/site-packages/devpi_web/static /devpi/+static


# Change to unprivileged user
USER devpi

# Inculde git version in web-interface (from docker compose)
ARG GIT_VERSION=unknown
ARG PROJECT_NAME=unknown
ARG PROJECT_URL=unknown
ARG BUILD_DATE=unknown
ARG LDAP_SEARCH_PASSWORD=unknown
RUN sed -i -E \
      's~\{\{PROJECT_URL\}\}~'${PROJECT_URL}'~' \
      /devpi/devpi_semantic_ui/templates/layout.pt; \
    sed -i -E \
      's~\{\{PROJECT_NAME\}\}~'${PROJECT_NAME}'~' \
      /devpi/devpi_semantic_ui/templates/layout.pt; \
    sed -i -E \
      's~\{\{GIT_VERSION\}\}~'${GIT_VERSION}'~' \
      /devpi/devpi_semantic_ui/templates/layout.pt; \
    sed -i -E \
      's~\{\{BUILD_DATE\}\}~'"${BUILD_DATE}"'~' \
      /devpi/devpi_semantic_ui/templates/layout.pt; echo BUILD_DATE: ${BUILD_DATE}; \
    sed -i -E \
	  's~\{\{LDAP_SEARCH_PASSWORD\}\}~'${LDAP_SEARCH_PASSWORD}'~' \
	  /devpi/devpi-ldap.yaml

# Entry point
EXPOSE 4040
CMD ["/devpi/run.sh"]

