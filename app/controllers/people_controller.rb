class PeopleController < ApplicationController

  def new
    @person = Person.new
    @income_year = @person.income_years.build
  end

  def create
    @person = Person.new(person_params)
    @person.set_current_income(params[:person][:income_years_attributes]['0'][:income])
    @person.set_age(params[:person][:birthday])
    @person.set_life_expectancy(params[:person][:sex])
    @person.backwards_project_income(@person.age - 22)
    @person.forwards_project_income(67 - @person.age)
    
    if @person.save
      redirect_to @person, alert: "Person created successfully!"
    else
      redirect_to new_person_path, alert: "Something went wrong creating a person..."
    end
  end

  def show
    @person = Person.find(params[:id])
  end

  private

    def person_params
      params.require(:person).permit(:sex, :birthday,  :claim_date, income_years_attributes: [:income, :year])
    end
end
