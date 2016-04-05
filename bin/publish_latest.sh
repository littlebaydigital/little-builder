#!/bin/bash

source `pwd`/bin/lib/_utils.sh
source `pwd`/bin/lib/_bintray.sh

REPOSITORY=$1
FILE=$2

tar cvf little-builder.tar.gz bin
publish_latest $REPOSITORY $FILE
