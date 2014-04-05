class CharitiesController < ApplicationController
  #==============================================#
  # CRUD                                         
  #==============================================#

  def index
    @charities = Charity.all
    render layout: "site"
  end

  def show
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @pages = @charity.pages
    @posts = @charity.posts.limit( 3 )
    @animals = @charity.animals.last( 3 )
    @user = @charity.user
    @lost_cases = @charity.lost_cases.last( 3 )
  end

  def new
    @charity = Charity.new
  end

  def edit
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @pages = @charity.pages
    @user = User.find( session[ :user_id ] )

    unless @charity.is_admin( @user )
      redirect_to charity_path( @charity ), flash: { overhead: "You do not have permission for that." }
    end
  end

  def update
    @charity = Charity.find_by_domain( params[ :id ] )
    @user = User.find( session[ :user_id ] ) unless session[ :auth ].blank?

    if @user.present && @charity.is_admin( @user )
      @charity.update_attributes( get_charity_params )

      flash[ :overhead ] = "Charity updated successfully"
    else 
      flash[ :overhead ] = "Charity update failed"
    end

    redirect_to charity_path( @charity )
  end

  def destroy
    @charity = Charity.find_by_domain( params[ :id ] )

    if session[ :auth ] && session[ :user_id ] == User.get_admin.id
      @charity.destroy
      
      redirect_to :back
    else
      redirect_to login_path
    end
  end

  def lost_and_found
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @pages = @charity.pages
    @lost_cases = @charity.lost_cases

    # for when the form is submitted
    if request.post?
      @case = @charity.lost_cases.create( get_lost_case_params )
      
      if @case.save!
        flash[ :overhead ] = "Successfully submitted lost and found case."
      else
        flash[ :overhead ] = "Submission failed. Try again."
      end 
      
      redirect_to charity_lost_and_found_path( @charity )
    end
  end

  #==============================================#
  # METHODS                                      
  #==============================================#

  # Displays charities that have names similar to the search needle
  # Param :org_name string -- needle to query the charity model 
  def search
    needle = params[ :charity ][ :org_name ]
    @charities = Charity.search( needle )

    flash[ :overhead ] = "No charities found" unless @charities.any?
    
    # change the layout for list display
    render "index", layout: "site"
  end

  # Verifies a charity number is authorised on revenue.ie
  # Param :charity_number integer -- the number to verify
  # Returns a JSON object with charity's information if valid
  def verify
    # require our libraries we need
    [
      "open-uri",
      "nokogiri",
      "timeout"
    ].each( &method( :require ))

    # the charity number the user provides
    number_to_verify = params[ :charity_number ]

    # the page to scrape
    url = "http://www.revenue.ie/en/business/authorised-charities-resident.html"

    # check if number has already been used
    charity = Charity.find_by_charity_number( number_to_verify )

    resp = {}

    if charity.blank?
      begin
        # break after 10 seconds waiting
        timeout( 10 ) do
          # get webpage
          doc = Nokogiri::HTML( open( url ))

          # get rows of the table
          rows = doc.css( "tr" )

          if rows.any?
            rows.each do |row|
              if row.css( "td:nth-child(1)" ).text == number_to_verify
                # success!
                resp = { 
                  status: "okay", 
                  id: row.css( "td:nth-child(1)" ).text, 
                  org_name: row.css( "td:nth-child(2)" ).text, 
                  address: row.css( "td:nth-child(3)" ).text 
                }
              end
            end
          else
            resp = {
              status: "no-list"
            }
          end
        end
      rescue Timeout::Error
        # the page took too long to load
        resp = {
          status: "504",
          error: "connection timeout"
        }
      end
    else
      # this charity exists, however has already in use
      resp = { 
        status: "taken",
        org_name: charity.org_name
      }
    end

    # return our JSON object
    render :json => resp.to_json
  end

  # checks if a domain is already in use
  def domain_check
    domain_to_check = params[ :domain ]
    rows_returned = Charity.find_by_domain( domain_to_check ).length
    render :json => { status: "okay", rows: rows_returned }.to_json
  end

  private
  # strong parameters - this is a whitelist allowing only these form attributes
  # required by Rails

  def get_charity_params
    params.require( :charity ).permit( :avatar, :banner_avatar, :domain, :org_name, :org_address, :org_tel, :charity_number, :charity_number_verified, :email, :template )
  end

  def get_user_params
    params.require( :user ).permit( :f_name, :l_name, :email, :email_confirmation, :password, :password_confirmation )
  end

  def get_lost_case_params
    params.require( :lost_case ).permit( :avatar, :owner_email, :animal_name, :description )
  end
end
