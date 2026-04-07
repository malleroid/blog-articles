FROM node:24.14.1-bookworm@sha256:df0c595f03d86c4ee091334106c80620b415e8fc5d65b320f7cea1d5ce2f690c

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
