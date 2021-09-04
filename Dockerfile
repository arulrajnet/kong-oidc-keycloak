FROM kong:2.5.0-alpine

LABEL description="Alpine + Kong 2.5.0 + kong-oidc plugin"
LABEL maintainer="me@arulraj.net"

USER root
RUN apk update && apk add git unzip luarocks
# RUN luarocks install --pin lua-resty-jwt 0.2.2-0
RUN luarocks install kong-oidc

USER kong