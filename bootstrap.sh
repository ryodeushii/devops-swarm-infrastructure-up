#!/usr/bin/env bash
#-----------------------------------------------------------------------------
echo "================================================================="
echo "==  Simple script to bootstrap initial setup in swarm cluster  =="
echo "================================================================="
echo "--------------------"
echo "-- Setup networks --"
echo "--------------------"
echo "1) Create external network for Traefik"
docker network create --driver=overlay traefik-public
echo "2)Create external network for Unison to sync through"
docker network create --driver=overlay sync-net

echo "Networks setup complete!!"
echo
#-----------------------------------------------------------------------------

set -e # exit on error
# docker login -u ${PUBLIC_REGISTRY_USERNAME:-} -p ${PUBLIC_REGISTRY_PASSWORD:-}

echo "* Grant execution rights to all scripts"
chmod +x scripts/**/*.sh

#-----------------------------------------------------------------------------

echo "============================"
echo "==  Convert ENVs to VARs  =="
echo "============================"
SKIP_TRAEFIK=${SKIP_TRAEFIK:-no}
SKIP_PORTAINER=${SKIP_PORTAINER:-no}
SKIP_MONITORING=${SKIP_MONITORING:-no}
SKIP_REGISTRY=${SKIP_REGISTRY:-no}
SKIP_GITEA=${SKIP_GITEA:-no}
SKIP_UNISON=${SKIP_UNISON:-no}
SKIP_SLEEP=${SKIP_SLEEP:-no}

#-----------------------------------------------------------------------------
if [ ${SKIP_TRAEFIK^^} == "YES" ]; then
  echo "SKIP_TRAEFIK is set to [${SKIP_TRAEFIK}] so bypassing Traefik config"
else
  echo "Configure & deploy Traefik..."
  cd /bootstrap/scripts/traefik
  ./install.sh
  echo 'Traefik deployment OK'
fi
echo

#-----------------------------------------------------------------------------
if [ ${SKIP_PORTAINER^^} == "YES" ]; then
  echo "SKIP_PORTAINER is set to [${SKIP_PORTAINER}] so bypassing Portainer config"
else
  echo "Configure Portainer"
  cd /bootstrap/scripts/portainer
  ./install.sh
  echo 'Portainer deployment OK'
fi
echo

#-----------------------------------------------------------------------------
if [ ${SKIP_MONITORING^^} == "YES" ]; then
  echo "SKIP_MONITORING is set to [${SKIP_MONITORING}] so bypassing Monitoring config"
else
  echo "Configure Monitoring"
  cd /bootstrap/scripts/monitoring
  ./install.sh
  echo 'Monitoring deployment OK'
fi
echo

#-----------------------------------------------------------------------------
if [ ${SKIP_REGISTRY^^} == "YES" ]; then
  echo "SKIP_REGISTRY is set to [${SKIP_REGISTRY}] so bypassing Registry config"
else
  echo 'Configure Registry:2'
  cd /bootstrap/scripts/registry
  ./install.sh
  echo 'Registry:2 deployment OK'
fi
echo

#-----------------------------------------------------------------------------
echo "Return to bootstrap root dir"
cd /bootstrap

echo
#-----------------------------------------------------------------------------
if [ ${SKIP_GITEA^^} == "YES" ]; then
  echo "SKIP_GITEA is set to [${SKIP_GITEA}] so bypassing Gitea config"
else
  echo "Setup Gitea"
  export DOMAIN=${GITEA_DOMAIN:-gitea.example.com}
  echo $DOMAIN
  docker stack deploy --with-registry-auth -c gitea/gitea.yml gitea
fi
echo

#-----------------------------------------------------------------------------
if [ ${SKIP_SLEEP^^} == "NO" ]; then
  echo "Sleep 2m before login to establish routes (initially is pretty slow)"
  sleep 2m
fi
echo

#-----------------------------------------------------------------------------
if [ ${SKIP_UNISON^^} == "YES" ]; then
  echo "SKIP_UNISON is set to [${SKIP_UNISON}] so bypassing Unison config"
else
  echo "Logging in to deployed registry..."
  docker login -u ${REGISTRY_USER:-admin} -p ${REGISTRY_PASSWORD:-admin} ${REGISTRY_DOMAIN:-registry.example.com}

  echo
  echo "Setup Unison"
  STACK_NAME=unison
  export CI_REGISTRY_IMAGE="${REGISTRY_DOMAIN:-registry.example.com}/${STACK_NAME}"
  docker stack rm ${STACK_NAME}
  docker-compose -f unison/docker-compose.yml build
  docker-compose push
  docker stack deploy --with-registry-auth -c unison/docker-compose.yml ${STACK_NAME}
fi
#-----------------------------------------------------------------------------
echo
echo
echo
echo "Finished bootstrap script!!!"
exit 0