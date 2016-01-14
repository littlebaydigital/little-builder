#!/usr/bin/env bash

source `pwd`/bin/lib/_utils.sh
source `pwd`/bin/lib/_rancher.sh

ENVIRONMENT=$1
SERVICE=$2

restart_service $ENVIRONMENT $SERVICE