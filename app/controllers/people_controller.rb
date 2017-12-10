class PeopleController < ApplicationController

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to @person, alert: "Person created successfully!"
    else
      redirect_to new_person_path, alert: "Something went wrong creating a person..."
    end
  end

  def show
    @person = Person.find(params[:id])
    if !@person.spouse.nil? && @person.spousal_benefit > @person.adjusted_benefit
      @optimal_claim = 'Spouse'
    else
      @optimal_claim = 'Independent'
    end
  end

  private

    def person_params
      params.require(:person).permit(:sex, :birthday,  :claim_date, :current_income)
    end
end
