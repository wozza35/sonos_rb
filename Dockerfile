FROM ruby:3.4.5-alpine

WORKDIR /app

COPY Gemfile sonos_rb.gemspec ./
COPY lib/sonos_rb/version.rb lib/sonos_rb/version.rb
RUN bundle install

COPY . .

ENTRYPOINT ["bundle", "exec", "bin/sonos_rb"]
