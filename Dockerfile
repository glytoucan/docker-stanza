FROM ruby:2.2.5

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for capybara-webkit
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb

# for a JS runtime
RUN apt-get install -y nodejs

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

#ADD Gemfile* $APP_HOME/
RUN git clone https://bitbucket.org/glycoSW/glytoucan-stanza.git
WORKDIR $APP_HOME/glytoucan-stanza

ENV BUNDLE_GEMFILE=$APP_HOME/glytoucan-stanza/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle

RUN bundle install

ADD . $APP_HOME
