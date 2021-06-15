FROM alpine
RUN apk update
# install deps
RUN apk add curl git openssh docker docker-compose bash

WORKDIR /bootstrap
COPY . ./

CMD ["bash", "bootstrap.sh"]