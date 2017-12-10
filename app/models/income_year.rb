class IncomeYear < ApplicationRecord
  belongs_to :person, required: false
  validates_presence_of :income
end
