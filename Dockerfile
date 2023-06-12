FROM ruby:3

RUN gem install bundler

COPY Gemfile /app/
COPY Gemfile.lock /app/
WORKDIR /app
RUN bundle install

ADD . /app

EXPOSE 9292
