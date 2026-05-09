FROM node:24.15.0-bookworm@sha256:34f0eb9d36f5163c16e8157aaa50c3bbb7a03aa744ce8668549d6f71d98b69cf

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
