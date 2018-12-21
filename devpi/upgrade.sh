#!/bin/sh
# Update server data - see ../README.md
#
# Can't just rename the directories as these are docker volumes (results
# in "Resource busy" errors).

DST=/devpi/server
SRC=/devpi/server-upgrade

find "$DST" -mindepth 1 -delete
find "$SRC" -maxdepth 1 -mindepth 1 -exec mv {} "$DST" \;

