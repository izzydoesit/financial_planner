class AddSpousalBenefitToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :spousal_benefit, :float, default: 0.0
  end
end
