class RemoveCompanyFromTopics < ActiveRecord::Migration[6.1]
  def change
    remove_column :topics, :company_id, :bigint
    rename_column :reviews, :select, :enrollment_status
  end
end
