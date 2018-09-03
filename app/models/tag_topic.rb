# == Schema Information
#
# Table name: tag_topics
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TagTopic < ApplicationRecord
  validates :name, presence: true

  has_many :taggings,
    primary_key: :id,
    foreign_key: :tag_topic_id,
    class_name: :Tagging,
    dependent: :destroy

  has_many :shortened_urls,
    through: :taggings,
    source: :shortened_url

  # returns the 5 most visited links for that TagTopic along with the number of times each link has been clicked
  def popular_links
  # the join will only return the original attributes of the ShortenedUrl objects even though we put additional attributes in the select.
  # to access these additional attributes, we can call them on the results of the query.
    shortened_urls.joins(:visits)
      .group(:long_url, :short_url)
      .order(Arel.sql('COUNT(visits.id) DESC'))
      .select('long_url, short_url, COUNT(visits.id) AS number_of_visits')
      .limit(5)
  end

end
