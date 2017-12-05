class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.integer :age
      t.date :birthday
      t.float :current_income
      t.integer :life_expectancy
      t.date :claim_date
      t.boolean :spousal_benefits
      t.float :estimated_SS_benefit

      t.timestamps
    end
  end
end
