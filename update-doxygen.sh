#!/bin/bash

BASEPATH=/home/doxygen

source ${BASEPATH}/lock_unlock

LOCKFILE=${BASEPATH}/doxygen.lock

# Create a lockfile (and delete it if we abort)
lock_unlock action=lock name=$LOCKFILE

echo "Updating git..."
cd ${BASEPATH}/sources
nice git pull

echo Updating doxygen docs
cd ${BASEPATH}
nice doxygen doxygen.conf

# Fix the index.html file <title> if necessary
perl -pi -e 's,<title>ResidualVM</title>,<title>ResidualVM :: Doxygen</title>,g' /var/www/doxygen/html/index.html

cp -R images /var/www/doxygen/html/
cp residualvm_tabs.css /var/www/doxygen/html/
cp favicon.ico /var/www/doxygen/html/

lock_unlock action=unlock name=$LOCKFILE
