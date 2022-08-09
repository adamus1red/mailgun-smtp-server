FROM alpine:3.16.2
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
