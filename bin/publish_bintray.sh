#!/bin/bash

source `pwd`/bin/lib/_utils.sh
source `pwd`/bin/lib/_bintray.sh

REPOSITORY=$1
FILE=$2
VERSION=$3

#tar cvf little-builder.tar.gz bin

if [ -z "$VERSION" ]
then
    echo "publishing latest"
    publish_latest $REPOSITORY $FILE
else
    echo "publishing version $VERSION"
    publish $REPOSITORY $FILE $VERSION

fi