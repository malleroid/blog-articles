FROM node:24.15.0-bookworm@sha256:e9891237dfbb1de60ce19e9ff9fac5d73ad9c37da303ad72ff2a425ad1057e71

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
