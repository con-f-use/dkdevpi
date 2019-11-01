#!/bin/sh

serverdir=/devpi/server
default_config=/devpi/  # dataindex.json
ldap_config=/devpi/devpi-ldap.yaml

if [ ! -e "$serverdir/.serverversion" ]; then
    echo "Warning: No configuration for devpi present. Creating one..." 1>&2
    devpi-server --serverdir "$serverdir" --import "$default_config"
    rm -rf /devpi/root /devpi/bloody dataindex.json
fi

ldap_flag=''
if ! grep -E 'password:\s*unknown' "$ldap_config" &>/dev/null; then
    echo "LDAP enabled!"
    ldap_flag="--ldap-config $ldap_config"
fi

echo "Starting devpi server" 1>&2
exec 2>&1 \
  devpi-server \
    --host 0.0.0.0 \
    --port 4040 \
    --role master \
    --serverdir "$serverdir" \
    --restrict-modify root \
    --theme /devpi/devpi_semantic_ui/ \
    $ldap_flag

# --outside-url
