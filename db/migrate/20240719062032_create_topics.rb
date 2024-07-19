class CreateTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :topics do |t|
      t.string :title
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :company, null: true, foreign_key: true

      t.timestamps
    end
  end
end
