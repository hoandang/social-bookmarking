# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ActiveRecord::Base
  attr_accessible :name
  has_many :associations
  has_many :bookmarks, through: :associations

  before_save { |tag| tag.name = name.downcase }
end
