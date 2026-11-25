FROM node:26.13.1-bookworm@sha256:893ea48106e988a5f91e69629d6472600daa9d0494adf7db87eb0b886ce82255

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
