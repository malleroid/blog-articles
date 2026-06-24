FROM node:24.17.0-bookworm@sha256:733e1c06ada118ed9f6133a31aa1290be6929664026fb28821500437c61f2c6f

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
