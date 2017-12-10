class Person < ApplicationRecord
  has_many :income_years
  accepts_nested_attributes_for :income_years, reject_if: :all_blank
  
  # before_save :calculate_first_SS_check
  def set_current_income(income)
    self[:current_income] = income
  end

  def set_age(birthday)
    self[:age] = ((Date.today - birthday.to_date)/365.25).to_i
  end

  def set_life_expectancy(sex)
    if sex == 'M'
      self[:life_expectancy] = 76
    else
      self[:life_expectancy] = 81
    end
  end

  def calculate_first_SS_check
    # figure out income base
    current_age = self[:age]
    years_backwards = current_age - 22
    years_forwards = 67 - current_age
    backwards_project_income(years_backwards) # populate earnings history
    forwards_project_income(years_forwards)
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

    def backwards_project_income(years)
      # for every year between current age and 22
        # create an IncomeYear instance
        # with previous year's income minus 2%
        # save it in current person's income_year array
    end 

    def forwards_project_income(years)
      # for every year between current age and 67
        # create an IncomeYear instance
        # with previous year's income plus 2%
        # save it in current person's income_year array
    end

    def calculate_AMIE(age, current_income)

    end

    def convert_AMIE_to_benefits(monthly_earnings)

    end
end
