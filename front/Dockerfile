FROM node:14.4.0-alpine

ARG WORKDIR
ARG CONTAINER_PORT
ARG API_URL

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    HOST=0.0.0.0  \
    API_URL=${API_URL} \
    NPM_CONFIG_PRODUCTION=false

WORKDIR ${HOME}

# for fibers, gyp, preventing SAOError
RUN apk add python make g++

COPY package*.json ./
RUN yarn install

COPY . .

RUN yarn run build

EXPOSE ${CONTAINER_PORT}