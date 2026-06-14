FROM ruby:3.4.5-alpine

WORKDIR /app

COPY . .

RUN bundle install

ENTRYPOINT ["ruby", "bin/sonos_rb"]
