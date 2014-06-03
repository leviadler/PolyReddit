class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :submitter_id
      t.integer :post_id

      t.timestamps
    end
    add_index :comments, :submitter_id
    add_index :comments, :post_id
  end
end
