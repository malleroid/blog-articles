FROM node:24.15.0-bookworm@sha256:29f7199e3b736f3649a20ea461fcebb44c847387c02dc5d4fa9ace29dc9b51d9

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
