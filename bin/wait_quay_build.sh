#!/bin/bash

IMAGE_REPOSITORY=$1
BUILD_TAG=$2
AUTH_TOKEN=${3:-$QUAYIO_AUTH_TOKEN}

current_dir="$(dirname "$0")"
source ${current_dir}/lib/_utils.sh
source ${current_dir}/lib/_bootstrap.sh

ensure_package "jq"

function waitForImage() {
	local imageRepository=$1
	local tag=$2
	echo "waiting for image $tag to build "
	while true; do
		local status=$(curl -H "Authorization: Bearer $AUTH_TOKEN" -s -o /dev/null -w "%{http_code}" https://quay.io/api/v1/repository/${imageRepository}/tag/$tag/images)
		if [[ $status == 200 ]]; then
			echo "success"
			break
		elif [[ $status == 404 ]]; then
			echo -n "."
			sleep 3
			continue
		else
			die "unexpected error status: $status"
		fi
	done
}

function getImageIdByTag() {
	local imageRepository=$1
	local tag=$2
	curl --fail --silent -H "Authorization: Bearer $AUTH_TOKEN" https://quay.io/api/v1/repository/${imageRepository}/tag/$tag/images | \
		jq -r '.images[0].id'
}

function tagImage() {
	local imageRepository=$1
	local tag=$2
	local imageId=$3
	curl --fail -s -o /dev/null -H "Authorization: Bearer $AUTH_TOKEN" -H "Content-Type: application/json" -X PUT -d "{\"image\": \"$imageId\"}" https://quay.io/api/v1/repository/${imageRepository}/tag/$tag || \
		die "failed to tag $tag on: $imageId"
}

waitForImage $IMAGE_REPOSITORY $BUILD_TAG

IMAGE_ID=$(getImageIdByTag $IMAGE_REPOSITORY $BUILD_TAG)
[[ $IMAGE_ID != "" ]] || die "failed to fetch image id for $BUILD_TAG"
echo "successfully built: $IMAGE_ID"

tagImage $IMAGE_REPOSITORY "master" $IMAGE_ID
tagImage $IMAGE_REPOSITORY "latest" $IMAGE_ID
