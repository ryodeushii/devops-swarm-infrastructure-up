#!/usr/bin/env bash
echo "Create external network for Traefik"
docker network create --driver=overlay traefik-public


set -e # exit on errorset -e # exit on error

DOMAIN="${MONITORING_DOMAIN:-sys.example.com}"
ID=$(docker info -f '{{.Swarm.NodeID}}')
USERNAME="${MONITORING_USERNAME:-admin}"
PASSWORD="${MONITORING_PASSWORD:-admin}"
HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)


echo "Base Domain for monitoring: ${DOMAIN}"
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

echo "Deploy Monitoring (swarmprom) stack"
docker stack deploy -c swarmprom.yml swarmprom