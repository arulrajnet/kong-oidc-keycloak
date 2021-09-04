#! /usr/bin/env sh

export KONG_SERVICE_HOST=${KONG_SERVICE_HOST:-kong}
export KONG_SERVICE_ADMIN_PORT=${KONG_SERVICE_ADMIN_PORT:-8001}

# Delete

## routes
curl -s -X DELETE http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/routes/92e33755-3d1a-4469-81c2-ca7dc98c589d
curl -s -X DELETE http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/routes/3c02b7c0-0e0b-466f-b9b3-332a1b458e02

## services
curl -s -X DELETE http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/services/c0505e29-360b-40b3-8f90-b36611cd38f3
curl -s -X DELETE http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/services/94157cc3-0e51-4950-8fdb-384f95987c09

# Create

## service

### Keycloak
curl -s -X POST http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/services \
    -d id=c0505e29-360b-40b3-8f90-b36611cd38f3 \
    -d name=keycloak \
    -d host=keycloak \
    -d port=8080 \
    -d protocol=http

### Httpbin
curl -s -X POST http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/services \
    -d id=94157cc3-0e51-4950-8fdb-384f95987c09 \
    -d name=httpbin \
    -d host=httpbin \
    -d port=80 \
    -d protocol=http

## routes

### Keycloak
curl -s -X POST http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/routes \
    -d id=92e33755-3d1a-4469-81c2-ca7dc98c589d \
    -d service.id=c0505e29-360b-40b3-8f90-b36611cd38f3 \
    -d paths[]=/auth \
    -d strip_path=false

### Httpbin
curl -s -X POST http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/routes \
    -d id=3c02b7c0-0e0b-466f-b9b3-332a1b458e02 \
    -d service.id=94157cc3-0e51-4950-8fdb-384f95987c09 \
    -d paths[]=/ \
    -d strip_path=false

# Create plugins