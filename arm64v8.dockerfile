FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM arm64v8/alpine:latest

# Add QEMU
COPY --from=builder qemu-aarch64-static /usr/bin

MAINTAINER technolengy@gmail.com

RUN apk update && apk --update add ruby ruby-irb ruby-io-console tzdata ca-certificates

ADD Gemfile /app/  

RUN apk --update add --virtual build-deps build-base ruby-dev \
    && gem install bundler \
    && cd /app \
    && bundle install \
    && apk del build-deps

ADD . /app  
RUN chown -R root:root /app  

WORKDIR /app

EXPOSE 25

CMD ["bundle", "exec", "ruby", "mail.rb"]
