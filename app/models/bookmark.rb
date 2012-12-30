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

  validates :url, uniqueness: { scope: :user_id }
  #validate :url_cannot_be_duplicated_per_user

  default_scope order: 'bookmarks.created_at DESC'

  def self.from_users_followed_by user
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    # followed_user_ids = user.followed_user_ids.join(',')
    where("user_id IN (#{followed_user_ids})", 
          user_id: user.id)
  end

  #def url_cannot_be_duplicated_per_user
    #current_user = User.find(self.user_id)
    #if current_user.bookmarks.any?{|b| b.url.eql? self.url }
      #errors.add(:url, "already added")
    #end
  #end
end
