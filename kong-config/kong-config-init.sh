#! /usr/bin/env sh
set -e
# set -x

export KONG_SERVICE_HOST=${KONG_SERVICE_HOST:-kong}
export KONG_SERVICE_ADMIN_PORT=${KONG_SERVICE_ADMIN_PORT:-8001}
export OIDC_CLIENT_ID=${OIDC_CLIENT_ID:-web-client}
export OIDC_CLIENT_SECRET=${OIDC_CLIENT_SECRET:-cf657905-6daa-4e65-806f-86dd7c968b78}

# Delete

## plugins
plugins=$(curl -s -X GET http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/plugins | jq -r '.data[]|.id')

for plugin in $plugins; do
  curl -s -X DELETE http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/plugins/$plugin
done

## routes
routes=$(curl -s -X GET http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/routes | jq -r '.data[]|.id')

for route in $routes; do
  curl -s -X DELETE http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/routes/$route
done

## services
services=$(curl -s -X GET http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/services | jq -r '.data[]|.id')

for service in $services; do
  curl -s -X DELETE http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/services/$service
done

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

## plugins

curl -s -X POST http://${KONG_SERVICE_HOST}:${KONG_SERVICE_ADMIN_PORT}/plugins \
  -d id=3d1b5e45-8b4b-4052-9f2e-297806d5902a \
  -d service.id=94157cc3-0e51-4950-8fdb-384f95987c09 \
  -d name=oidc \
  -d config.client_id=${OIDC_CLIENT_ID} \
  -d config.client_secret=${OIDC_CLIENT_SECRET} \
  -d config.discovery=http://localhost:8000/auth/realms/master/.well-known/openid-configuration