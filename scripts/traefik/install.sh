#!/usr/bin/env bash
echo "Create external network for Traefik"
docker network create --driver=overlay traefik-public


set -e # exit on errorset -e # exit on error

DOMAIN="${TRAEFIK_DOMAIN:-traefik.sys.example.com}"
ID=$(docker info -f '{{.Swarm.NodeID}}')
EMAIL="${CERT_EMAIL:-hello@example.com}"
USERNAME="${TRAEFIK_USERNAME:-admin}"
PASSWORD="${TRAEFIK_PASSWORD:-admin}"
HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)


echo "Domain for Traefik: ${DOMAIN}"
echo "Node ID: ${ID}"
echo "Cert Email: ${EMAIL}"
echo "USERNAME: ${USERNAME}"
echo "Tag node"
docker node update --label-add traefik-public.traefik-public-certificates=true $ID

echo "Export variables"
export DOMAIN=${DOMAIN}
export NODE_ID=${ID}
export EMAIL=${EMAIL}
export USERNAME=${USERNAME}
export HASHED_PASSWORD=${HASHED_PASSWORD}
echo "Deploy Traefik stack"
docker stack deploy -c traefik.yml traefik