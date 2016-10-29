class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :file
      t.references :attachable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
