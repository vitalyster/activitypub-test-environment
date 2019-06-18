FROM alpine:3.9

RUN apk add postgresql redis curl git yarn libc6-compat gcompat

RUN apk add gcc g++ libc-dev libffi-dev libxml2-dev libxslt-dev icu-dev libidn-dev postgresql-dev protobuf-dev make ruby-dev ruby-bundler

RUN adduser --disabled-password mastodon

USER mastodon

WORKDIR /home/mastodon

ENV MASTODON_VERSION 2.9.0

RUN curl -L -O https://github.com/tootsuite/mastodon/archive/v${MASTODON_VERSION}.tar.gz && tar -xzvf v${MASTODON_VERSION}.tar.gz

WORKDIR /home/mastodon/mastodon-${MASTODON_VERSION}

RUN bundle config build.nokogiri --use-system-libraries && bundle install --path vendor/bundle

RUN bundle add bigdecimal irb json foreman

RUN rm .yarnclean && yarn install --pure-lockfile

ENV LOCAL_DOMAIN m.test
ENV LOCAL_HTTPS true
ENV STREAMING_API_BASE_URL ws://${LOCAL_DOMAIN}:4000

ADD run.sh /

CMD "/run.sh"

