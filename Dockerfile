FROM ubuntu:latest

# prepare docker
RUN apt update
RUN apt install -y curl
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN docker-compose -version


WORKDIR /bootstrap
COPY . ./

CMD ["bash", "bootstrap.sh"]