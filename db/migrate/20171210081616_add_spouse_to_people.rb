class AddSpouseToPeople < ActiveRecord::Migration[5.0]
  def change
    add_reference :people, :spouse, foreign_key: true
  end
end
