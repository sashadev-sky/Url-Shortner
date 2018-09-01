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
end
