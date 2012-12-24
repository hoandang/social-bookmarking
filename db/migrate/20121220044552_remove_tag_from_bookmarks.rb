class RemoveTagFromBookmarks < ActiveRecord::Migration
  def up
    remove_column :bookmarks, :tag_id
    remove_column :bookmarks, :integer
  end

  def down
    add_column :bookmarks, :integer, :string
    add_column :bookmarks, :tag_id, :string
  end
end
