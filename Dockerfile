FROM node:24.15.0-bookworm@sha256:91447bc57243b852a21e0ff3553f531f0d4b66257a564b106c79d9e00f3aa14e

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
