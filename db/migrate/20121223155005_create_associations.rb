class CreateAssociations < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.integer :bookmark_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
