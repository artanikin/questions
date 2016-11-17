class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :commentable, polymorphic: true, index: true
      t.references :author, references: :user, index: true

      t.timestamps
    end
    add_foreign_key :comments, :users, column: :author_id
  end
end
