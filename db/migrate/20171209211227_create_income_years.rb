class CreateIncomeYears < ActiveRecord::Migration[5.0]
  def change
    create_table :income_years do |t|
      t.string :year
      t.float :income
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
