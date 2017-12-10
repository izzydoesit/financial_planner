class Person < ApplicationRecord
  has_many :income_years
  accepts_nested_attributes_for :income_years, reject_if: :all_blank
  
  before_save :set_age, :set_life_expectancy, :set_retirement_age
  after_save :create_current_income_record, :project_income, :calculate_monthly_amie, :calculate_pia
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

  def set_retirement_age
    retirement_age = 67.0
    birth_year = self[:birthday].year

    case birth_year
      when 1938
        retirement_age = 65.2
      when 1939
        retirement_age = 65.4
      when 1940
        retirement_age = 65.5
      when 1941
        retirement_age = 65.7
      when 1942
        retirement_age = 65.8
      when 1943..1954
        retirement_age = 66.0
      when 1955
        retirement_age = 66.2
      when 1956
        retirement_age = 66.3
      when 1957
        retirement_age = 66.5
      when 1958
        retirement_age = 66.7
      when 1959
        retirement_age = 66.8
      end

      self[:full_retirement_age] = retirement_age
  end

  def create_current_income_record
    self.income_years.create(income: self[:current_income], year: Date.today.year)
  end

  def calculate_first_SS_check
    # project earnings history
    create_current_income_record
    project_income 
    # calculate Average Monthly Indexed Earnings (top 35 earning years)
    calculate_monthly_amie
    # convert AMIE to benefits
    calculate_pia
    # calculate spouse
    compare_spousal_benefit
    # adjust benefits according to year they take
    adjust_benefits
    # benefit reduction +/- 36 months
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
    maximum_point = 10600
    maximum_amie = self[:monthly_amie_base] > maximum_point ? maximum_point : self[:monthly_amie_base]
    bend_point_1 = 885
    bend_point_2 = 5336
    benefit = 0
    
    if maximum_amie >= bend_point_2
      benefit += (maximum_amie - bend_point_2) * 0.15
      benefit += (bend_point_2 - bend_point_1) * 0.35
      benefit += bend_point_1 * 0.90
    elsif maximum_amie >= bend_point_1
      benefit += (maximum_amie - bend_point_1) * 0.35
      benefit += bend_point_1 * 0.90
    else
      benefit += maximum_amie * 0.9
    end

    self[:maximum_benefit] = benefit.round(2)

    full_retirement_date = self[:birthday] >> (self[:full_retirement_age] * 12)
    months_from_retirement = ((full_retirement_date - self[:claim_date]) / 30).to_i
    if months_from_retirement.abs >= 1 
      adjust_benefits(months_from_retirement)
    end
  end

  def compare_spousal_benefit
  end

  def adjust_benefits(difference)
    adjusted_benefit = self[:maximum_benefit]
    if difference > 0   # deduct benefits
      months = [difference, 36].min 
      months.times do |i|
        adjusted_benefit -=  (adjusted_benefit * (5/9 * 0.01))
      end 
      if difference > 36
        months_over_36 = (difference - 36).to_i
        months_over_36.times do
          adjusted_benefit -= (adjusted_benefit * (5/12 * 0.01))
        end
      end
    else   # add benefits
      months = [difference.abs, 36].min
      months.times do
        adjusted_benefit +=  (adjusted_benefit * (5.0/9 * 0.01))
      end 
      
      if difference.abs > 36
        months_over_36 = (difference.abs - 36).to_i
        months_over_36.times do
          adjusted_benefit += (adjusted_benefit * (5.0/12 * 0.01))
        end
      end
    end
    
    self[:adjusted_benefit] = adjusted_benefit.round(2)
  end
end
