#!/usr/bin/env bash
set -e # exit on errorset -e # exit on error

DOMAIN="${REGISTRY_DOMAIN:-registry.sys.example.com}"
ID=$(docker info -f '{{.Swarm.NodeID}}')
USERNAME="${REGISTRY_USER:-admin}"
PASSWORD="${REGISTRY_PASSWORD:-admin}"
HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)


echo "Domain for Registry: ${DOMAIN}"
echo "Node ID: ${ID}"
echo "USERNAME:${USERNAME}$ PASSWORD:${PASSWORD}$"

echo "Export variables"
export DOMAIN=${DOMAIN}
export NODE_ID=${ID}

export USERNAME=${USERNAME}
export PASSWORD=${PASSWORD}

export ADMIN_USER=${USERNAME}
export ADMIN_PASSWORD=${PASSWORD}

export HASHED_PASSWORD=${HASHED_PASSWORD}

echo "Deploy Registry stack"
docker stack deploy --with-registry-auth -c registry.yml registry