class AnimalsController < ApplicationController
  def index
    get_charity_info
    @animals = @charity.animals
  end

  def show
    get_charity_info
    @animal = @charity.animals.find_by_name( get_animal_name )
  end

  def new
    get_charity_info
    @animal = @charity.animals.build
  end

  def create
    get_charity_info

    if is_auth
      @animal = @charity.animals.create( get_animal_params )

      if @animal.valid?
        @animal.save!

        redirect_to charity_animal_path( @charity, @animal ), flash: { overhead: "Animal saved successfully" }
      else
        render 'new'
      end
    else
      redirect_to animals_path, flash: { overhead: "You are not permitted for that." }
    end
  end

  def edit
    get_charity_info

    if is_auth
      @animal = @charity.animals.find_by_name( get_animal_name )
    else
      redirect_to animals_path, flash: { overhead: "You are not permitted for that." }
    end
  end

  def update
    @charity = Charity.find_by_domain( params[ :charity_id ] )

    if is_auth
      @animal = @charity.animals.find_by_name( get_animal_name ).update_attributes( get_animal_params )

      flash[ :overhead ] = "Successfully updated animal"
    else
      flash[ :overhead ] = "You are not permitted for that."
    end

    redirect_to charity_animals_path( @charity )
  end

  def destroy
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @animal = @charity.animals.find_by_name( get_animal_name )

    if @animal.destroy
      redirect_to charity_animals_path( @charity ), flash: { overhead: "Deletion successful" } 
    else 
      redirect_to charity_animal_path( @charity, @animal ), flash: { overhead: "Deletion failed" }
    end
  end

  # adopt an animal
  def adopt
    get_charity_info
    @animal = @charity.animals.find_by_name( params[ :animal_id ].capitalize )

    unless @animal.can_adopt?
      redirect_to charity_animal_path( @charity, @animal ), flash: { overhead: "This animal cannot be adopted" }
    end
  end

  private
    
  def is_auth
    ( session[ :auth ] and session[ :user_id ] == @charity.user_id )
  end

  def get_charity_info
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @pages = @charity.pages
  end

  def get_animal_params
    params.require( :animal ).permit( :avatar, :name, :species, :breed, :can_adopt, :can_sponsor, :description, :owner_email )
  end

  def get_animal_name
    params[ :id ].capitalize
  end
end
