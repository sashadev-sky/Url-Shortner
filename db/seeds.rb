# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ShortenedUrl.destroy_all
Visit.destroy_all
Tagging.destroy_all
TagTopic.destroy_all
User.destroy_all

u1 = User.create!(email: 'abcdefg@gmail.com')
u2 = User.create!(email: 'hello123@gmail.com')

su1 = ShortenedUrl.create_for_user_and_long_url!(u1, 'https://stackoverflow.com/questions/34424154/rails-validate-uniqueness-of-two-columns-together')
su2 = ShortenedUrl.create_for_user_and_long_url!(u2, 'https://gittobook.org/books/148/tech-interview-handbook')
su3 = ShortenedUrl.create_for_user_and_long_url!(u2, 'https://guides.rubyonrails.org/active_record_querying.html')

Visit.record_visit!(u1, su1)
Visit.record_visit!(u1, su1)
Visit.record_visit!(u1, su2)

Visit.record_visit!(u2, su2)
Visit.record_visit!(u2, su2)
Visit.record_visit!(u2, su1)
Visit.record_visit!(u2, su3)

tt1 = TagTopic.create!(name: 'Search')
tt2 = TagTopic.create!(name: 'Movies')

Tagging.create!(shortened_url: su1, tag_topic: tt1)
Tagging.create!(shortened_url: su2, tag_topic: tt1)
Tagging.create!(shortened_url: su3, tag_topic: tt2)
