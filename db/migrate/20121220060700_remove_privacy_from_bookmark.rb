class RemovePrivacyFromBookmark < ActiveRecord::Migration
  def up
    remove_column :bookmarks, :privacy
  end

  def down
    add_column :bookmarks, :privacy, :boolean
  end
end
