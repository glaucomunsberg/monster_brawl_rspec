FROM ruby:3.2.2

ENV EDITOR nano
ENV RAILS_ENV $RAILS_ENV

VOLUME /usr/local/bundle

RUN mkdir -p /app

RUN apt update

RUN apt-get install -y build-essential libpq-dev nodejs git nano 
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY api/Gemfile /app/Gemfile
COPY api/Gemfile.lock /app/Gemfile.lock

RUN bundle config set force_ruby_platform true

RUN bundle config set specific_platform x86_64-linux

RUN bundle update sprockets-rails
#RUN gem install nokogiri -v 1.16.2

RUN bundle install

COPY docker/api/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN mkdir -p /app/server/tmp/pids

RUN rm -f /app/server/tmp/pids/server.pid

# permission in app folder to user
RUN chown -R 1000:1000 /app

CMD ["rails", "server", "-b", "0.0.0.0"]
