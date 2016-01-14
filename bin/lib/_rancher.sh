#!/usr/bin/env bash

function restart_service() {
    local environment=$1
    local service=$2

    ensureVar CATTLE_ACCESS_KEY
    ensureVar CATTLE_SECRET_KEY

    curl -u "${CATTLE_ACCESS_KEY}:${CATTLE_SECRET_KEY}" \
        -X POST \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{"rollingRestartStrategy":""}' \
        "http://rancher.republicwealth.com.au/v1/projects/${environment}/services/${service}/?action=restart"

}