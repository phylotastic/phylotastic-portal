FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client
RUN mkdir /phylotastic-portal
WORKDIR /phylotastic-portal
COPY Gemfile /phylotastic-portal/Gemfile
COPY Gemfile.lock /phylotastic-portal/Gemfile.lock
RUN bundle install
COPY . /phylotastic-portal

CMD ["/phylotastic-portal/exe/startup.sh"]