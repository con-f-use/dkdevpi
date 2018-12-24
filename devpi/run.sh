
serverdir=/devpi/server

if [ ! -e "$serverdir/.serverversion" ]; then
    debpi-server --init --serverdir "$serverdir"
fi

devpi-server \
  --host 0.0.0.0 \
  --port 4040 \
  --serverdir "$serverdir" \
  --restrict-modify root
