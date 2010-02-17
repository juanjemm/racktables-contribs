#!/bin/sh

# This shell script reloads a RackTables demo database. It requires:
# 1. Unpacked RackTables tarball
# 2. init-auth annex file
# 3. dictdump.php helper script
# 4. optional file with XKCD art database

usage()
{
	echo "Usage: $0 [version [database [yes|no]]]"
	exit 1
}

V=${1:-0.17.7}
Vu=${V//./_}
DB=${2:-demo_$Vu}
DODEMO=${3:-yes}
MYNAME=`realpath $0`
MYDIR=`dirname $MYNAME`

cd "$HOME/RackTables-$V" || exit 2

echo "DROP DATABASE IF EXISTS $DB; CREATE DATABASE $DB CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql information_schema
echo "source install/init-structure.sql" | mysql $DB
echo "source install/init-dictbase.sql" | mysql $DB
echo "source $MYDIR/init-auth-$V.sql" | mysql $DB
$MYDIR/dictdump.php | mysql $DB

[ "$DODEMO" = "yes" ] || exit
echo "source install/init-sample-racks.sql" | mysql $DB
[ ${V#0.16} = $V ] || exit
[ -s "$HOME/RackTables-XKCD-art-569.sql" ] && echo "source $HOME/RackTables-XKCD-art-569.sql" | mysql $DB