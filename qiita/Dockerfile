FROM node:24.11.1-bookworm@sha256:822e393234e85c7557d1536176601635e6faae698d8c8935fda7cd15c98bc29c

RUN apt-get update

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
