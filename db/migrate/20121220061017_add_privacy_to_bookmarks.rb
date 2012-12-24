class AddPrivacyToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :privacy, :boolean, default: true
  end
end
