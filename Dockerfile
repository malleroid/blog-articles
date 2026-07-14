FROM node:24.18.0-bookworm@sha256:d5adb040f90e206d1dc91453d08a4fa4165ec0faebd62a3421e6181a14e7f41f

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
