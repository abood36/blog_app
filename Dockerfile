# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t blog_app .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name blog_app blog_app

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.3
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client \
    nodejs \
    npm \
    git \
    libpq-dev \
    libyaml-dev \
    pkg-config && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="production" \
    BUNDLE_DEPLOYMENT="0"

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Install Rails
RUN gem install rails

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN mkdir -p tmp/pids



# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
