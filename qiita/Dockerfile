FROM node:24.13.0-bookworm@sha256:bdc72529eb387cb3a2c0ef0c7c45192ef29600db5a3d62f0d6e62d59752df718

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
