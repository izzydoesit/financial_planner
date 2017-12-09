class Person < ApplicationRecord
  before_validation :set_age, :set_life_expectancy
  before_save :calculate_first_SS_check

  def :set_age
    self[:age] = Date.today - self[:birthday]
  end

  def :set_life_expectancy
    if self[:sex] == 'M'
      self[:life_expectancy] = 76
    else
      self[:life_expectancy] = 81
    end
  end

  def :calculate_first_SS_check
    # figure out income base
    backwards_project_income # populate earnings history
    forwards_project_income
    # calculate Average Monthly Indexed Earnings (top 35 earning years)
    average_monthly_indexed_earnings = calculate_AMIE(self[:age], self[:current_income])
    # convert AMIE to benefits
    monthly_income = convert_AMIE_to_benefits(AMIE)
    # calculate spouse
    # adjust benefits according to year they take
    # benefit reduction +/- 36 months

    self[:estimated_SS_benefit] = monthly_income
  end

  private
    def calculate_AMIE(age, current_income)

    end

    def convert_AMIE_to_benefits(monthly_earnings)

    end
end
