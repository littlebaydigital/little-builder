#!/usr/bin/env bash

function restart_service() {
    local environment=$1
    local service=$2
    local batchSize=$3
    local interval=$4

    ensureVar CATTLE_ACCESS_KEY
    ensureVar CATTLE_SECRET_KEY
    ensureVar RANCHER_API_URL

    curl -u "${CATTLE_ACCESS_KEY}:${CATTLE_SECRET_KEY}" \
        -X POST \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{"rollingRestartStrategy": {"batchSize": '${batchSize}', "intervalMillis": '${interval}'}}' \
        "${RANCHER_API_URL}/projects/${environment}/services/${service}/?action=restart"
}

function upgrade_service() {
    local environment=$1
    local service=$2
    local image=$3

    ensureVar CATTLE_ACCESS_KEY
    ensureVar CATTLE_SECRET_KEY
    ensureVar RANCHER_API_URL

    local inServiceStrategy=`curl -u "${CATTLE_ACCESS_KEY}:${CATTLE_SECRET_KEY}" \
        -X GET \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        "${RANCHER_API_URL}/projects/${environment}/services/${service}/" | jq '.upgrade.inServiceStrategy'`
    local updatedServiceStrategy=`echo ${inServiceStrategy} | jq ".launchConfig.imageUuid=\"docker:${image}\""`
    echo "updatedServiceStrategy "${updatedServiceStrategy}
    echo "sending update request"
    curl -u "${CATTLE_ACCESS_KEY}:${CATTLE_SECRET_KEY}" \
        -X POST \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d "{
          \"inServiceStrategy\": ${updatedServiceStrategy}
          }
        }" \
        "${RANCHER_API_URL}/projects/${environment}/services/${service}/?action=upgrade"
}

function finish_upgrade() {
    local environment=$1
  	local service=$2

    echo "waiting for service to upgrade "
  	while true; do
      local serviceState=`curl -u "${CATTLE_ACCESS_KEY}:${CATTLE_SECRET_KEY}" \
          -X GET \
          -H 'Accept: application/json' \
          -H 'Content-Type: application/json' \
          "${RANCHER_API_URL}/projects/${environment}/services/${service}/" | jq '.state'`

      case $serviceState in
          "\"upgraded\"" )
              echo "completing service upgrade"
              curl -u "${CATTLE_ACCESS_KEY}:${CATTLE_SECRET_KEY}" \
                -X POST \
                -H 'Accept: application/json' \
                -H 'Content-Type: application/json' \
                -d '{}' \
                "${RANCHER_API_URL}/projects/${environment}/services/${service}/?action=finishupgrade"
              break ;;
          "\"upgrading\"" )
              echo -n "."
              sleep 3
              continue ;;
          *)
	            die "unexpected upgrade state: $serviceState" ;;
      esac
  	done
}
