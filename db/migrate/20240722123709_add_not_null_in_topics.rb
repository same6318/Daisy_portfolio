class AddNotNullInTopics < ActiveRecord::Migration[6.1]
  def change
    change_column_null :topics, :title, false
    change_column_null :topics, :content, false
  end
end
