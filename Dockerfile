FROM ruby:3.4.5-alpine

WORKDIR /app

COPY . .

ENTRYPOINT ["ruby", "app/sonos_rb.rb"]
