class Person < ApplicationRecord
  has_many :income_years
  accepts_nested_attributes_for :income_years, reject_if: :all_blank
  
  before_save :set_age, :set_life_expectancy
  after_save :create_current_income_record, :project_income, :calculate_monthly_amie
  # before_save :calculate_first_SS_check

  def set_current_income(income)
    self[:current_income] = income
  end

  def set_age
    self[:age] = ((Date.today - self[:birthday].to_date)/365.25).to_i
  end

  def set_life_expectancy
    if self[:sex] == 'M'
      self[:life_expectancy] = 76
    else
      self[:life_expectancy] = 81
    end
  end

  def create_current_income_record
    self.income_years.create(income: self[:current_income], year: Date.today.year)
  end

  def calculate_first_SS_check
    # project earnings history
    backwards_project_income 
    forwards_project_income
    # calculate Average Monthly Indexed Earnings (top 35 earning years)
    calculate_monthly_amie
    # convert AMIE to benefits
    calculate_pia
    # calculate spouse
    compare_spousal_benefit
    # adjust benefits according to year they take
    adjust_benefits
    # benefit reduction +/- 36 months

    self[:estimated_SS_benefit] = monthly_income
  end

  def project_income
    # assume growth rate of 2%
    previous_years = self[:age] - 22
    years_left = 70 - self[:age]
    this_year = Date.today.year
    this_year_income = self[:current_income]

    previous_years.times do |i|
      previous_year = this_year - i - 1
      previous_year_income = (this_year_income * 0.98**(i+1)).round(2)
      self.income_years.create(year: previous_year, income: previous_year_income)
    end

    this_year = Date.today.year
    this_year_income = self[:current_income]

    years_left.times do |i|
      future_year = this_year + (i + 1)
      future_year_income = (this_year_income * 1.02**(i+1)).round(2)
      self.income_years.create(year: future_year, income: future_year_income)
    end
  end 

  def calculate_monthly_amie
    # average income of top 35 years
    incomes = self.income_years.map { |iy| iy.income }.sort.last(35)
    self[:monthly_amie_base] = ((incomes.inject(0) { |sum, i| sum + i } / incomes.size) / 12).round(2)
  end

  def calculate_pia
    
  end

  def compare_spousal_benefit
  end

  def adjust_benefits
  end
end
