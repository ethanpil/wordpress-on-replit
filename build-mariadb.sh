#! /bin/bash --

TARGZ=mariadb-5.5.68-linux-i686.tar.gz
TARGZ_URL=https://archive.mariadb.org/mariadb-5.5.68/bintar-linux-x86/mariadb-5.5.68-linux-i686.tar.gz
MARIADB_INIT_PL="$PWD/mariadb_init.pl"
MY_CNF="$PWD/my.cnf"
#README_TXT="${0%/*}/README.txt"
test -f "$MARIADB_INIT_PL"

TMPDIR=$PWD
TMPABSDIR=$PWD

test "$TMPABSDIR"

if ! test -f $TMPDIR/${TARGZ}; then
  wget -O $TMPDIR/${TARGZ}.download ${TARGZ_URL}
  mv -f $TMPDIR/${TARGZ}.download $TMPDIR/${TARGZ}
fi

rm -rf $TMPDIR/mariadb-preinst
mkdir -p $TMPDIR/mariadb-preinst
cp -f "$MARIADB_INIT_PL" "$TMPDIR"/mariadb-preinst/
if test -f "$MY_CNF"; then
  cp "$MY_CNF" "$TMPDIR"/mariadb-preinst/
else
  touch "$TMPDIR"/mariadb-preinst/my.cnf
fi
if test -f "$README_TXT"; then
  cp "$README_TXT" "$TMPDIR"/mariadb-preinst/
else
  touch "$TMPDIR"/mariadb-preinst/README.txt
fi
cd $TMPDIR/mariadb-preinst
tar xzvf $TMPABSDIR/${TARGZ} ${TARGZ%.tar.*}/share
tar xzvf $TMPABSDIR/${TARGZ} ${TARGZ%.tar.*}/bin/mysqld
tar xzvf $TMPABSDIR/${TARGZ} ${TARGZ%.tar.*}/bin/resolveip
tar xzvf $TMPABSDIR/${TARGZ} ${TARGZ%.tar.*}/bin/my_print_defaults
tar xzvf $TMPABSDIR/${TARGZ} ${TARGZ%.tar.*}/scripts/mysql_install_db

cd ${TARGZ%.tar.*}
strip -s bin/mysqld

# Disable chowning.
perl -pi -e '$_=""if/^\s*chown\s+/' scripts/mysql_install_db

scripts/mysql_install_db --basedir="$PWD" --force --datadir="$PWD"/data

# The default password is empty, but we change it to invalid so that login
# will not be possible until someone sets up a working password e.g. with
# SET password=PASSWORD('working').
echo "UPDATE mysql.user SET password='refused' WHERE user='root'" |
    bin/mysqld --bootstrap --datadir=./data --language=./share/english \
    --console --log-warnings=0 --loose-skip-ndbcluster \
    --loose-skip-pbxt --loose-skip-federated --loose-skip-aria \
    --loose-skip-maria --loose-skip-archive
rm -rf scripts
rm -f share/*.sql
rm -f data/aria_log*
mkdir log
cd ..  # Back to $TMPDIR/mariadb-preinst.
mv ${TARGZ%.tar.*} portable-mariadb
mv mariadb_init.pl my.cnf README.txt portable-mariadb/
chmod 755 portable-mariadb/mariadb_init.pl
tar -cjv --group=mysql -f ../portable-mariadb.tbz2 portable-mariadb
rm -f $TMPDIR/${TARGZ}
cd "$TMPABSDIR"
rm -rf mariadb-preinst
ls -l "$TMPABSDIR"/portable-mariadb.tbz2
