class AddAuthorToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_reference :answers, :author, references: :users
    add_foreign_key :answers, :users, column: :author_id
  end
end
