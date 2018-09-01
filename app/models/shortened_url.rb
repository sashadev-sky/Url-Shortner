# == Schema Information
#
# Table name: shortened_urls
#
#  id           :bigint(8)        not null, primary key
#  long_url     :string           not null
#  short_url    :string           not null
#  submitter_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  include ActiveModel::Validations

  validates :long_url, presence: true, url: true
  validates :short_url, presence: true, uniqueness: true

  belongs_to :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: 'Visit',
    foreign_key: :shortened_url_id,
    primary_key: :id,
    dependent: :destroy

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source:  :visitor

  has_many :taggings,
    class_name: 'Tagging',
    foreign_key: :shortened_url_id,
    primary_key: :id,
    dependent: :destroy

  has_many :tag_topics,
    through: :taggings,
    source: :tag_topic


  # factory method creates a shortened url and persists it to the database

  # alternative syntax would have been to just call SortenedUrl.create! with those parameters,
  # then dont need to store in local variable and call save! on it
  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(
      submitter_id: user.id,
      long_url: long_url,
      short_url: ShortenedUrl.random_code
    )
  end

  # provides a unique random short_url
  def self.random_code
    loop do
      random_code = SecureRandom.urlsafe_base64(16)
      return random_code unless ShortenedUrl.exists?(short_url: random_code)
    end
  end

  def num_clicks
    visits.count
  end

  # if I didnt add a no duplicates scope block to the association, I would have to call .distinct here
  # either way works, with the scope block looks cleaner to me.
  def num_uniques
    visitors.count
  end

  # same goes for this method
  def num_recent_uniques
    visits
      .select(:user_id)
      .where('created_at > ?', 10.minutes.ago)
      .distinct
      .count
  end

end
