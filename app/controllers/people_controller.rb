class PeopleController < ApplicationController

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    @person.set_age(params[:person][:birthday])
    @person.set_life_expectancy(params[:person][:sex])
    
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
      params.require(:person).permit(:sex, :birthday, :current_income, :claim_date)
    end
end
