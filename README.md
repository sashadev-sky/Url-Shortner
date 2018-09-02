## URL Shortner

### Concepts (personal use)
- building a CLI tool
- `launchy` gem: allows us to pop open the URL in the browser even though we have not built in the browser
- Base64 encoding (`SecureRandom`)
- ActiveRecord methods
  - `exists?`
  - `::create!` vs `::new` & `#save!`
**-> use create instead of new/save syntax in factory methods because the other class calling the factory method will get returned to it a "true" instead of the object**
- ActiveRecord relations
  - join table
  - `dependent: :destroy`
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
