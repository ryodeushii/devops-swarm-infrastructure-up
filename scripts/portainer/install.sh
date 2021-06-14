#!/usr/bin/env bash
set -e # exit on error
DOMAIN="${PORTAINER_DOMAIN:-portainer.sys.example.com}"
ID=$(docker info -f '{{.Swarm.NodeID}}')


echo "Domain for Portainer: ${DOMAIN}"
echo "Node ID: ${ID}"
echo "Tag node..."
docker node update --label-add portainer.portainer-data=true $ID

echo "Export variables"
export DOMAIN=${DOMAIN}
export NODE_ID=${ID}

echo "Deploy Portainer stack"
docker stack deploy -c portainer.yml portainer