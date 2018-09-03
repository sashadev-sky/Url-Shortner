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
  validate :no_spamming, :nonpremium_max

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

  def self.prune(n)
    ShortenedUrl
      .joins(:submitter)
      .joins('LEFT JOIN visits ON visits.shortened_url_id = shortened_urls.id')
      .where("(shortened_urls.id IN (
        SELECT shortened_urls.id
        FROM shortened_urls
        JOIN visits
        ON visits.shortened_url_id = shortened_urls.id
        GROUP BY shortened_urls.id
        HAVING MAX(visits.created_at) < \'#{n.minute.ago}\'
      ) OR (
        visits.id IS NULL and shortened_urls.created_at < \'#{n.minutes.ago}\'
      )) AND users.premium = \'f\'")
      .destroy_all
  end

  private

  def no_spamming
    # we can chain the `where` queries methods because the contents of the Relation are not fetched until needed (laziness)
    # since the first Relation returned by where is never evaluated, we can build a 2nd relation from it
    last_minute = ShortenedUrl
      .where('created_at >= ?', 1.minute.ago)
      .where(submitter_id: submitter_id)
      .length

    errors[:maximum] << 'of five short urls per minute' if last_minute >= 5
  end

  def nonpremium_max
    return if User.find(self.submitter_id).premium

    number_of_urls = ShortenedUrl
      .where(submitter_id: submitter_id)
      .length

    if number_of_urls >= 5
      errors[:only] << 'premium members can create more than 5 short urls'
    end
  end

end
