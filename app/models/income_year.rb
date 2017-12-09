class IncomeYear < ApplicationRecord
  belongs_to :person
  validates_presence_of :income
end
