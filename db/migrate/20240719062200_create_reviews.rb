class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :work_life_balance, null: false, default: 0
      t.integer :workplace_atmosphere, null: false, default: 0
      t.integer :flex_system, null: false, default: 0
      t.integer :remote_work, null: false, default: 0
      t.integer :harassment_prevention, null: false, default: 0
      t.integer :parental_care_leave, null: false, default: 0
      t.integer :childcare_support, null: false, default: 0
      t.integer :welfare_facilities, null: false, default: 0
      t.integer :mental_health_care, null: false, default: 0
      t.integer :evaluation_system, null: false, default: 0
      t.integer :promotion_salary, null: false, default: 0
      t.integer :overtime_holiday_work, null: false, default: 0
      t.integer :allowances_subsidies, null: false, default: 0
      t.integer :training_education_support, null: false, default: 0
      t.integer :career_support, null: false, default: 0
      t.integer :work_engagement, null: false, default: 0
      t.text :content
      t.boolean :select
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
