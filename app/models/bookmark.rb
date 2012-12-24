# == Schema Information
#
# Table name: bookmarks
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  url         :string(255)
#  description :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  privacy     :boolean          default(TRUE)
#

class Bookmark < ActiveRecord::Base
  attr_accessible :description, :title, :url, :privacy

  belongs_to :user
  has_many :associations
  has_many :tags, through: :associations

  validates :title, presence: true, length: { maximum: 140 }
  validates :url, presence: true, format: URI::regexp(%w(http https))
  validates :user_id, presence: true

  default_scope order: 'bookmarks.created_at DESC'

  def self.from_users_followed_by user
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
end
