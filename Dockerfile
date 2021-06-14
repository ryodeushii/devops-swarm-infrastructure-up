FROM ubuntu:latest

# prepare docker
RUN apt update
RUN apt install -y curl
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh

WORKDIR /bootstrap
COPY . ./

CMD ["sh", "bootstrap.sh"]