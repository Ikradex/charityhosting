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
    if session[ :auth ]
      # the index page of the site
      init_page_title = "index"
      init_page_content = "<h1>This is your new charity page!</h1><p>On your control panel, go to \"Pages\" and \"Edit\" to edit this page or add more pages to your website.</p>"

      @charity = Charity.new( get_post_params )
      @charity.user_id = session[ :user_id ]

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
    else
      # redirect user back to login page with a reference to return to this page again
      redirect_to login_path( :return => request.url )
    end
  end

  def account
  end

  private
  # strong parameters - this is a whitelist allowing only these form attributes
  # required by Rails

  def get_post_params
    params.require( :charity ).permit( :domain, :org_name, :email, :template )
  end
end
