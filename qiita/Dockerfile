FROM node:24.13.1-bookworm@sha256:00e9195ebd49985a6da8921f419978d85dfe354589755192dc090425ce4da2f7

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
