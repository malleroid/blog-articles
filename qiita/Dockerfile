FROM node:24.14.0-bookworm@sha256:dcac36e9d0d3049214862dac30af9f1ee86fccaa8d3bd3a0399b59d6f1bec0eb

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
