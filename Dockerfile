FROM node:24.21.0-bookworm@sha256:22553920add6fb1fd909104346924cd30b4b3ac76ca2980f3b8dba8ede3cf945

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
