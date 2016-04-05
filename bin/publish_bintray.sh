#!/bin/bash

source `pwd`/bin/lib/_utils.sh
source `pwd`/bin/lib/_bintray.sh

REPOSITORY=$1
FILE=$2
VERSION=$3

#tar cvf little-builder.tar.gz bin

if $VERSION
then
    publish_latest $REPOSITORY $FILE
else
    public $REPOSITORY $FILE $VERSION
fi