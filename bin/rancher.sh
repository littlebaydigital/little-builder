#!/usr/bin/env bash

source `pwd`/bin/lib/_bootstrap.sh
source `pwd`/bin/lib/_utils.sh
source `pwd`/bin/lib/_rancher.sh

ensure_package "jq"

COMMAND=$1
ENVIRONMENT=$2
SERVICE=$3

case $COMMAND in
    "restart" )
        BATCH_SIZE=$4
        INTERVAL=$5
        restart_service $ENVIRONMENT $SERVICE $BATCH_SIZE $INTERVAL ;;
    "upgrade" )
        IMAGE=$4
        upgrade_service $ENVIRONMENT $SERVICE $IMAGE ;;
    "finish_upgrade" )
        finish_upgrade $ENVIRONMENT $SERVICE ;;
    *)
        die "unkown command: ["$COMMAND"]" ;;
esac
