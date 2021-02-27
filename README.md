# Artificial Education

Ruby on Rails application initialized with [Hix on Rails][hixonrails].

## System dependencies

- Ruby version: 2.7.0
- Rails version: 6.1.3
- Database: PostgreSQL
- Redis installed

## Configuration

Copy an existing sample environment file. Run:
```bash
$ cp .env.sample .env
```

and edit newly created `.env` file. The minimum you are going to need are
credentials to your local PostgreSQL database.

Then, install all the necessary gems:
```bash
bundle install
```

## Database creation

In order to create the database with all the necessary seed data, run:
```bash
$ rails db:create db:schema:load db:seed
```

## How to start the app

Start the Ruby on Rails server with:
```bash
rails server
```
To run Sidekiq, launch another process with:
```bash
bundle exec sidekiq
```

## Code quality checks

The application provides the following code quality analysis tools:

- [Fasterer][fasterer]
- [RuboCop][rubocop] with [RuboCop Performance][rubocop-performance] and [RuboCop Rails][rubocop-rails]

To run them locally:

```bash
$ bundle exec fasterer
$ bundle exec rubocop
```

[hixonrails]: https://hixonrails.com
[rubocop]: https://github.com/rubocop-hq/rubocop
[rubocop-performance]: https://github.com/rubocop-hq/rubocop-performance
[rubocop-rails]: https://github.com/rubocop-hq/rubocop-rails
[fasterer]: https://github.com/DamirSvrtan/fasterer
