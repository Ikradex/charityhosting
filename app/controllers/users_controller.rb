class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
      @user = User.new( get_post_params )

      if @user.save
        session[ :user_id ] = @user.id
        session[ :auth ] = true
        redirect_to charities_path
      else 
        render 'new'
      end
  end

  def login
  end

  def logout
    reset_session

    redirect_to :back
  end

  def authenticate
    user = User.find_by_email( params[ :user ][ :email ] )

    if !user.nil? and user.authenticate( params[ :user ][ :password ] )
      reset_session

      session[ :user_id ] = user.id
      session[ :auth ] = true

      return_link = params[ :return ] ? params[ :return ] : charities_path
      redirect_to return_link
    else
      redirect_to :back
    end
  end

  private 
    def get_post_params 
      params.require( :user ).permit( :f_name, :l_name, :email, :email_confirmation, :password, :password_confirmation )
    end
end
