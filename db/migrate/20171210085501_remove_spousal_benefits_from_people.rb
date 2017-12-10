class RemoveSpousalBenefitsFromPeople < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :spousal_benefits, :boolean
  end
end
