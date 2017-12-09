class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.integer :age
      t.string :sex
      t.date :birthday
      t.float :current_income
      t.integer :life_expectancy
      t.date :claim_date
      t.boolean :spousal_benefits, default: false
      t.float :estimated_ss_benefit

      t.timestamps
    end
  end
end
