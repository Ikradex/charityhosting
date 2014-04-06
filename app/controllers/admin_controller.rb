class AdminController < ApplicationController
  def index
    @admin = User.get_admin

    if is_admin
      @requests_pending = Request.where( approved: false ).limit( 5 )
      @charities_validated = Charity.last( 5 )
    else
      redirect_to login_path( :return => reques.url )
    end
  end

  # view all charities
  # paginate by 30
  def charities_index
    @admin = User.get_admin
    @page_break_num = 30
    @charities = Charity.all.paginate( page: params[ :page ], per_page: @page_break_num )
  end

  # show a particular charity
  def charity_show
    @admin = User.get_admin
    @charity = Charity.find_by_domain( params[ :charity_id ] )
  end

  def charity_edit
  end

  # validates a charity to be generated
  # validated charities must be created through approved requests
  def validate_charity
    @form_errors = Array.new

    if request.post?
      # get the request based on secret token given through email
      @token = params[ :user ][ :approval_token ]

      @request = Request.find_by_approval_token( @token )

      if @request.present? and @request.approved?
        # convert our request to charity parameters for filtering
        params[ :charity ] = @request.attributes

        user_id = 0;
        # create new user if not logged in
        if params[ :user ] and ! session[ :auth ]
          @user = User.create( get_user_params )

          if @user.save!
            user_id = @user.id
            session[ :user_id ] = user_id
            session[ :auth ] = true
          else
            @user.errors.full_messages.each_with_index do |err, index|
              err = "User error: " + err
              @user.errors.full_messages[ index ] = err
            end

            ( @form_errors << @user.errors.full_messages ).flatten!
          end
        else
          user_id = session[ :user_id ]
        end

        @charity = Charity.create( get_charity_params )
        @charity.user_id = user_id

        if @charity.valid?
          @charity.save!

          if @form_errors.size <= 0
            # this prevents users from creating duplicate charities through the validation page
            @request.update_attributes( approval_token: nil )

            redirect_to @charity, flash: { overhead: "Congratulations! Charity validation successful." }
          else
            render 'validate_charity', flash: { overhead: "Charity validation unsuccessful" }
          end
        else
          @charity.errors.full_messages.each_with_index do |err, index|
            err = "Charity error: " + err
            @charity.errors.full_messages[ index ] = err
          end

          ( @form_errors << @charity.errors.full_messages ).flatten!
          render 'validate_charity', { token: @token }
        end
      else
        redirect_to charities_path, flash: { overhead: "Request not approved yet or does not exist" }
      end
    else
      @request = Request.find_by_approval_token( params[ :token ] )
      @user = ( session[ :auth ] ) ? User.find( session[ :user_id ] ) : User.new

      # request token expires after one week
      if @request.nil? or ( Time.now - @request.created_at ) >= 1.week
        redirect_to charities_path, flash: { overhead: "Token has expired or been used already" }
      end
    end
  end

  def invalidate_charity
    @charity = Charity.find( params[ :charity_id ] )
    @charity.update_attributes( suspended: true )

    redirect_to :back
  end

  # should not be invoked unless you know what you're doing
  # it is recommended you invalidate a charity rather than destroy it
  def charity_destroy
    @charity = Charity.find( params[ :charity_id ] ).take

    if @charity.destroy
      redirect_to :back
    end
  end

  private

  def is_admin
    session[ :auth ] and session[ :user_id ] == User.get_admin.id
  end

  def get_charity_params
    params.require( :charity ).permit( :domain, :org_name, :org_address, :org_tel, :charity_number, :charity_number_verified, :email, :template )
  end

  def get_user_params
    params.require( :user ).permit( :f_name, :l_name, :email, :email_confirmation, :password, :password_confirmation )
  end
end
