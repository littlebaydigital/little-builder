# Republic Builder

Continuously buliding and delivering the Republic, one Microservice at a time.

## Rancher
To upgrade a service

    bin/rancher.sh upgrade {projectId} {serviceId} {image}
    bin/rancher.sh finish_upgrade {projectId} {serviceId}

To restart a service

    bin/rancher.sh restart {projectId} {serviceId} {batchSize} {intervalMillis}

The `projectId` is id of the Environment. It can be obtained by going to a Service and
selecting `View in API`

## Bintray
Deletes `latest` artifact and uploads a new one

    bin/publish_latest.sh {repository} {file}

## Quay.IO
Wait for a docker image to finish building

    bin/wait_quay_build.sh {imageRepo} {tag} {authToken}

`authToken` is optional if the environment variable `QUAYIO_AUTH_TOKEN` is set.
