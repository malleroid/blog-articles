FROM node:24.18.1-bookworm@sha256:19cd848a0e073d34bd8cd5545a1b6b4d28489b3e3b607366621ced442bd5f6b4

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
