FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y wget curl htop git unzip build-essential

RUN wget -qO- https://deb.nodesource.com/setup_9.x | bash -

RUN apt-get install -y nodejs

RUN apt-get install -y virtualenv python3 python3-dev

RUN npm install -g truffle ethereumjs-testrpc

RUN virtualenv -p python3 ~/.venv-py3

RUN ~/.venv-py3/bin/pip install web3

RUN mkdir /data

VOLUME ["/data"]

EXPOSE 8545 8546 8181 8182 8451 8452 30301 30302
