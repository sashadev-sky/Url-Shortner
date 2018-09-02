# URL Shortener

A simple CLI tool that takes in an arbitrarily-long URL and will shorten it for the user. Subsequent users can then give the short URL back to the tool and be redirected to the original URL.

## Overview
- Written in Ruby.
- Uses the `launchy gem` to allow us to pop open the URL in the browser without actually building in the browser.
- To see how it works:
  - run `bundle install` from within the project directory.
  - run `rails runner bin/cli`.
  - when prompted for an email: enter one of the emails already in the database, which you can find in `db/seeds.rb`.

## Features
- Tracks clickthroughs for business analytics.
- Allows users to choose from a set of predefined `TagTopic`s for links (e.g., news, music, etc.).
  - Allows users to search for the most visited links by topic.
- Spam protection: users cannot submit more than 5 URLs in a single minute.
- A `premium` option is available for users: the number of total URLs non-premium users can submit is limited to 5.
- Stale URLs can be purged from the database with the `ShortenedUrl::prune` method or by running the Rake Task `prune` in `lib/tasks`.

### Concepts (personal use)
- building a CLI tool
- `launchy` gem
- Base64 encoding (`SecureRandom`)
- Associations
  - join table
  - `dependent: :destroy`
- ActiveRecord methods
  - `exists?`
  - `::create!` vs `::new` & `#save!`
**-> use create instead of new/save syntax in factory methods because the other class calling the factory method will get returned to it a "true" instead of the object**
- `ActiveRecord::Relation`
  - lazy evaluation of `Relation` objects
- `ActiveRecord::QueryMethods`
  - `select`
    - `distinct` chained onto `select`
  - `where`
  - `joins`
  - `group`
  - `limit`
  - `order`
    - Rails 6 will need us to wrap our raw SQL in `Arel.sql`
- ActiveRecord time methods
  - Using the `created_at` column to interact with Time objects
- `ActiveModel::EachValidator`
  - custom url validation
- `rails runner`: loads the Rails environment for us, so we'll be able to use classes without requiring them explicitly. It also connects to the DB so we can query tables
- creating a Rake task
