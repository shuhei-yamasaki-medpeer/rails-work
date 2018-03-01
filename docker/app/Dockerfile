FROM ruby:2.5-alpine

RUN apk update && \
    apk upgrade && \
    apk add --update build-base mysql-dev nodejs tzdata curl fontconfig yarn && \
    rm -rf /var/cache/apk/* && \
    cd /usr/share \
    && curl -L https://github.com/Overbryd/docker-phantomjs-alpine/releases/download/2.11/phantomjs-alpine-x86_64.tar.bz2 | tar xj \
    && ln -s /usr/share/phantomjs/phantomjs /usr/bin/phantomjs

ENV app /work/app
WORKDIR $app

# bundle install pathをdata containarに変更
ENV BUNDLE_PATH /bundle

ARG app_dir
COPY $app_dir $app
