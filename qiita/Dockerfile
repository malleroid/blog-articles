FROM node:24.13.0-bookworm@sha256:1de022d8459f896fff2e7b865823699dc7a8d5567507e8b87b14a7442e07f206

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
