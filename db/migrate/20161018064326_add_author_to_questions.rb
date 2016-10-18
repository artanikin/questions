class AddAuthorToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :author, references: :users
    add_foreign_key :questions, :users, column: :author_id
  end
end
