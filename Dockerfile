FROM ruby:3.4.5-alpine

WORKDIR /app

COPY . .

ENTRYPOINT ["ruby", "bin/sonos_rb"]
