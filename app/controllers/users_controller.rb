class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new( get_post_params )

    if @user.save
      sess_auth
      redirect_to charities_path
    else
      render 'new'
    end
  end

  def login
    # empty action, we only need it so we can display the login form
  end

  def logout
    # destroys all session cookies
    reset_session
    # return to previous page once logged out
    redirect_to :back
  end

  def authenticate
    # we can search for rows in a database based on any attribute of the corresponding model
    # we can find a user based on their email or name or password
    user = User.find_by_email( params[ :user ][ :email ] )

    # the ? indicates that the method returns a boolean
    # the authenticate method is a rails generated method
    # it automatically hashes input passwords and compares them against the user's :password_digest attribute
    if !user.nil? and user.authenticate( params[ :user ][ :password ] )
      # always good practice to reset session cookies on login
      reset_session

      sess_auth( user )

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

  def sess_auth( user )
    # save the user in the session
    session[ :user_id ] = user.id
    # authenticate user
    session[ :auth ] = true
  end
end
