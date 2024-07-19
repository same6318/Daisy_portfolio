class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name,        null: false
      t.integer :capital,    null: false
      t.integer :employee,   null: false
      t.integer :sales,      null: false
      t.text :description,   null: false
      t.string :address,     null: false
      t.integer :industry,   null: false
      t.string :company_url
      t.string :contact

      t.timestamps
    end
  end
end
