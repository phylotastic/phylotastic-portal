# FROM ruby:2.5.0
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client
# RUN mkdir /phylotastic-portal
# WORKDIR /phylotastic-portal
# COPY Gemfile /phylotastic-portal/Gemfile
# COPY Gemfile.lock /phylotastic-portal/Gemfile.lock
# RUN bundle install
# COPY . /phylotastic-portal
#
# CMD ["/phylotastic-portal/exe/startup.sh"]


FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]