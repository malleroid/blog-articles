FROM node:24.16.0-bookworm@sha256:8530f76a96d88820d288761f022e318970dda93d01536919fbc16076b7983e63

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
