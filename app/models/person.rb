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

  def backwards_project_income(years)
    this_year = Date.today.year
    this_years_income = self[:current_income]
    # for every year between current age and 22
    years.times do 
      # income is previous year's income minus 2%
      this_year = this_year - 1 
      this_years_income = (this_years_income * 0.98).round(2)
      IncomeYear.create(person_id: self[:id], year: this_year, income: this_years_income)
    end
  end 

  def forwards_project_income(years)
    this_year = Date.today.year
    this_years_income = self[:current_income]
    # for every year between current age and 67
    years.times do 
      # income is previous year's income plus 2%
      this_year = this_year + 1 
      this_years_income = (this_years_income * 1.02).round(2)
      IncomeYear.create(person_id: self[:id], year: this_year, income: this_years_income)
    end
  end

  def calculate_amie(age, current_income)

  end

  def convert_amie_to_benefits(monthly_earnings)

  end
end
