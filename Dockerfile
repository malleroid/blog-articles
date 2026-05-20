FROM node:24.15.0-bookworm@sha256:2bf80b777346679077f4932d429e3d06ab7cd5b9a8f5b020d684100891d33bd5

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
