class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, index: true
      t.references :author, references: :user, index: true
      t.integer :value

      t.timestamps
    end
    add_foreign_key :votes, :users, column: :author_id
  end
end
