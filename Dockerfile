FROM ruby:3.4.5-alpine AS builder

WORKDIR /app

COPY . .

RUN apk add --no-cache build-base && bundle install

FROM ruby:3.4.5-alpine

WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

ENTRYPOINT ["ruby", "bin/sonos_rb"]
