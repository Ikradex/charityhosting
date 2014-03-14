class AdminController < ApplicationController
  def index
    @admin = User.get_admin

    if is_admin
      @requests_pending = Request.where( approved: false ).limit( 5 )
      @charities_validated = Charity.last( 5 )
    else
      redirect_to login_path
    end
  end

  def validate_charity
    if request.post?
      @request = Request.where( approval_token: params[ :user ][ :approval_token ] ).take
      @form_errors = Array.new

      if !@request.blank? and @request.approved?
        # convert our request to charity parameters for filtering
        params[ :charity ] = @request.attributes

        # the index page of the site
        init_pages = [ "index", "animals", "lost_and_found", "donate" ]
        user_id = 0;

        # create new user if not logged in
        if params[ :user ] and !session[ :auth ]
          @user = User.create( get_user_params )

          if @user.save!
            user_id = @user.id
            session[ :user_id ] = user_id
            session[ :auth ] = true
          else
            @form_errors |= @user.errors.full_messages
          end
        else
          user_id = session[ :user_id ]
        end

        @charity = Charity.create( get_charity_params )
        @charity.user_id = user_id

        if @charity.valid? and @charity.save!
          # init pages
          init_pages.each do |init_page|
            page = @charity.pages.create( title: init_page  )

            if page.valid? and page.save!
              # get the content of all init partials
              init_page_content = render_to_string( "pages/_" + init_page + "_page_content", layout: false )
              content = page.create_content( content_src: init_page_content )

              if content.valid? and content.save!
                @form_errors |= content.errors.full_messages
              end
            else
              @form_errors |= page.errors.full_messages
            end
          end

          if @form_errors.size > 0
            # this prevents users from creating duplicate charities through the validation page
            @request.approval_token = "";

            redirect_to @charity, flash: { overhead: "Congratulations! Charity validation successful." }
          else
            render 'validate_charity', flash: { overhead: "Charity validation unsuccessful" }
          end
        else
          render 'validate_charity'
        end
      else
        redirect_to :back, flash: { overhead: "Request not approved yet or does not exist" }
      end
    else
      @request = Request.where( approval_token: params[ :token ] ).take
      @user = ( session[ :auth ] ) ? User.find( session[ :user_id ] ) : User.new

      # request token expires after one week
      if @request.nil? or ( Time.now - @request.created_at ) >= 1.week
        redirect_to charities_path, flash: { overhead: "Token has expired or been used already" }
      end
    end
  end

  def invalidate_charity
    @charity = Charity.find( params[ :charity_id ] )

    #@charity.update_attributes( suspended: true )
  end

  def destroy_charity
    @charity = Charity.find( params[ :charity_id ] )

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
