FROM node:24.19.0-bookworm@sha256:538e581635ea0180e8cf02297a4054d4b883be79a8697f1d0c44f66948ed748a

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
