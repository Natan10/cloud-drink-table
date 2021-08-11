FROM ruby:2.6.7

RUN apt-get update -qq 

WORKDIR /app 

COPY Gemfile Gemfile.lock ./
RUN gem install bundler --no-document
RUN bundle install

COPY . .

EXPOSE 3000 

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]