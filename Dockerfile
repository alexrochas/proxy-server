FROM ruby:2.3.1

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

ENV RACK_ENV production
ENV PORT 8080

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["ruby","./fake-service.rb"]
