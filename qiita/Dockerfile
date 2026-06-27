FROM node:24.18.0-bookworm@sha256:fdddfb3e688158251943d52eba361de991548f6814007acba4917ae6b512d6be

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
