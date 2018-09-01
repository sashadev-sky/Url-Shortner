# == Schema Information
#
# Table name: visits
#
#  id               :bigint(8)        not null, primary key
#  user_id          :integer          not null
#  shortened_url_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Visit < ApplicationRecord
  belongs_to :shortened_url

  belongs_to :visitor,
  class_name: 'User',
  foreign_key: :user_id,
  primary_key: :id

  # convenience factory method that creates a Visit object recording a visit from a User to the given ShortenedUrl
  def self.record_visit!(user, shortened_url)
    Visit.create!(user_id: user.id, shortened_url_id: shortened_url.id)
  end

end
