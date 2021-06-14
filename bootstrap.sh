#!/usr/bin/env bash
set -e # exit on error
echo "Grant execution rights to all scripts"
chmod +x scripts/**/*.sh

echo "Configure & deploy Traefik..."
cd /bootstrap/scripts/traefik
./install.sh
echo 'Traefik deployment OK'

echo "Configure Portainer"
cd /bootstrap/scripts/portainer
./install.sh
echo 'Portainer deployment OK'

echo "Configure Monitoring"
cd /bootstrap/scripts/monitoring
./install.sh
echo 'Monitoring deployment OK'

echo "Return to bootstrap root dir"
cd /bootstrap
