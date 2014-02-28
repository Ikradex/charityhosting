class CharitiesController < ApplicationController
  def index
    @charities = Charity.all
  end

  def new
    @charity = Charity.new
    # create a page relating to the charity id
    @page = @charity.pages.build
    # create content relating to the page id
    @content = @page.build_content
  end

  def create
    # if logged in
    #if session[ :auth ]
    # the index page of the site
    init_page_title = "index"
    init_page_content = "<h1>This is your new charity page!</h1><p>On your control panel, go to \"Pages\" and \"Edit\" to edit this page or add more pages to your website.</p>"
    user_id = 0;

    if params[ :user ]
      @user = User.create( get_user_params )
      @user.save!

      user_id = @user.id
      session[ :user_id ] = user_id
      session[ :auth ] = true
    else
      user_id = session[ :user_id ]
    end

    @charity = Charity.new( get_charity_params )
    @charity.user_id = user_id

    if @charity.save
      @page = @charity.pages.create( :title => init_page_title )
      # ! indicates that the variable has being modified
      @page.save!
      @content = @page.create_content( :content_src => init_page_content )
      @content.save!

      redirect_to @charity
    else
      render 'new'
    end
    #else
    # redirect user back to login page with a reference to return to this page again
    #redirect_to login_path( :return => request.url )
    #end
  end

  def search
    render text: params.inspect
    #@charities = Charity.search( params.require( :charity ).permit( :search ))
    #render 'index'
  end

  def verify
    number_to_verify = params[ :charity_number ]

    url = "http://www.revenue.ie/en/business/authorised-charities-resident.html"
    json = { status: "no-list" }

    require "open-uri"
    doc = Nokogiri::HTML( open( url ))
    doc.css( "tr" ).each do |row|
      if row.css( "td:nth-child(1)" ).text == number_to_verify
        json = { status: "okay", id: row.css( "td:nth-child(1)" ).text, org_name: row.css( "td:nth-child(2)" ).text, address: row.css( "td:nth-child(3)" ).text }
      end
    end

    render :json => json.to_json
  end

  private
  # strong parameters - this is a whitelist allowing only these form attributes
  # required by Rails

  def get_charity_params
    params.require( :charity ).permit( :domain, :org_name, :email, :template )
  end

  def get_user_params
    params.require( :user ).permit( :f_name, :l_name, :email, :email_confirmation, :password, :password_confirmation )
  end
end
