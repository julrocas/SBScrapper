ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . .
