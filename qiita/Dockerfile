FROM node:26.12.1-bookworm@sha256:52dd743dc3b494cba5bc8c13507ac984507addb8a087c626dc98dcffa53133d4

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
