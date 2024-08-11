class ChangecolumnReview < ActiveRecord::Migration[6.1]
  def change
    change_column_default :reviews, :enrollment_status, from: true, to: false
  end
end
