# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  premium    :boolean          default(FALSE)
#

class User < ApplicationRecord
  # rails 5 default validator
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  has_many :submitted_urls,
    class_name: 'ShortenedUrl',
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: 'Visit',
    foreign_key: :user_id,
    primary_key: :id

  has_many :visited_urls,
    -> { distinct },
    through: :visits,
    source: :shortened_url
end
