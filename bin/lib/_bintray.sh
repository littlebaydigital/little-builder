#!/bin/bash

function publish_latest() {
    local repository=$1
    local filename=$2

    ensureVar BINTRAY_USER
    ensureVar BINTRAY_APIKEY

    curl -u$BINTRAY_USER:$BINTRAY_APIKEY \
         -X DELETE \
         https://api.bintray.com/packages/${repository}/versions/latest \
     || die "Failed to delete ${repository}/versions/latest"

    curl -T ${filename} \
         -u$BINTRAY_USER:$BINTRAY_APIKEY \
         -H "X-Bintray-Publish:1" \
         https://api.bintray.com/content/${repository}/latest/ \
     || die "Failed to publish ${repository}/versions/latest"
}

function publish() {
    local repository=$1
    local artifactVersion=$2
    local filename=$3

    ensureVar BINTRAY_USER
    ensureVar BINTRAY_APIKEY

    curl -T ${filename} \
         -u$BINTRAY_USER:$BINTRAY_APIKEY \
         -H "X-Bintray-Publish:1" \
         https://api.bintray.com/content/${repository}/${artifactVersion}/ \
     || die "Failed to publish ${repository}/${artifactVersion}"
}
