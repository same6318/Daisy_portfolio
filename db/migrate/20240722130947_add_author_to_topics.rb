class AddAuthorToTopics < ActiveRecord::Migration[6.1]
  def change
    add_column :topics, :author_name, :boolean, default: false
  end
end
