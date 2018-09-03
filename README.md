# URL Shortener

A simple CLI tool that takes in an arbitrarily-long URL and will shorten it for the user. Subsequent users can then give the short URL back to the tool and be redirected to the original URL.

## Overview
- Written in Ruby.
- Uses the `launchy gem` to allow us to pop open the URL in the browser without actually building in the browser.
- To see how it works:
  - make sure PostgreSQL is running.
  - run `bundle install` from within the project directory.
  - run `./setup`.
    - if you get a permission error, run `chmod +x setup` and then `./setup` again.
  - run `rails runner bin/cli`.
  - when prompted for an email: enter one of the emails already in the database, which you can find in `db/seeds.rb`.

## Features
- Tracks clickthroughs for business analytics.
- Allows users to choose from a set of predefined `TagTopic`s for links (e.g., news, music, etc.).
  - Allows users to search for the most visited links by topic.
- Spam protection: users cannot submit more than 5 URLs in a single minute.
- A `premium` option is available for users: the number of total URLs non-premium users can submit is limited to 5.
- Stale URLs can be purged from the database with the `ShortenedUrl::prune` method or by running the Rake Task `prune.rake` in `lib/tasks`.

#### Concepts (personal use)
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
  - `#attributes`
- lazy evaluation of `ActiveRecord::Relation` objects
- ActiveRecord Query Interface
  - `select`
    - `distinct` chained onto `select`
  - `where`
    - `find`, `find_by`, `find_by_#{attribute}`, etc. all return the first matching instance from the DB, `where` returns a collection of instances, regardless of the number.
  - `joins`
  - `group`
  - `limit`
  - `order`
    - Rails 6 will need us to wrap our raw SQL in `Arel.sql`
- ActiveRecord time methods
  - Using the `created_at` column to interact with Time objects
- `ActiveModel::EachValidator`
  - custom url validation
- client-side email validation
- `rails runner`: loads the Rails environment for us, so we'll be able to use classes without requiring them explicitly. It also connects to the DB so we can query tables
- creating a `Rake task`
