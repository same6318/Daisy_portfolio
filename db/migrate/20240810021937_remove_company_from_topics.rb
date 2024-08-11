class RemoveCompanyFromTopics < ActiveRecord::Migration[6.1]
  def change
    remove_column :topics, :company_id, :bigint
    rename_column :reviews, :select, :enrollment_status
    change_column_default :reviews, :enrollment_status, default: false
    change_column_null :reviews, :enrollment_status, null: false
  end
end
