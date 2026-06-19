FROM node:24.17.0-bookworm@sha256:032e78d7e54e352129831743737e3a83171d9cc5b5896f411649c597ce0b11ea

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
