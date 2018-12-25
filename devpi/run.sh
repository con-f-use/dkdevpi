
serverdir=/devpi/server
default_config=/devpi/dataindex.json

if [ ! -e "$serverdir/.serverversion" ]; then
    devpi-server --serverdir "$serverdir" --init
    devpi-server --serverdir "$serverdir" --import "$default_config"
    rm -f "$default_config"
fi

devpi-server \
  --host 0.0.0.0 \
  --port 4040 \
  --serverdir "$serverdir" \
  --restrict-modify root \
  --theme /devpi/
