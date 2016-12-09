class CreateSubscribes < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribes do |t|
      t.belongs_to :question, foreign_key: true, index: true
      t.references :author, references: :user, index: true

      t.timestamps
    end
    add_foreign_key :subscribes, :users, column: :author_id
  end
end
