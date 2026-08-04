FROM node:24.19.0-bookworm@sha256:da4221677e02b54ef6335adfa447578d512ad14f251024fb92ea433c2c102760

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
