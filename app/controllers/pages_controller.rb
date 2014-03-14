class PagesController < ApplicationController
  def show
    # sometimes the page's id can be either as id or page_id in the request parameters
    # if neither are present (eg. http://charityhosting.ie/charities/catactiontrust ) 
    # then the page request must be the index
    
    id = params[ :id ] ? params[ :id ] : params[ :page_id ] ? params[ :page_id ] : "index"
    @charity = Charity.where( domain: params[ :charity_id ] ).take
    @page = @charity.pages.where( title: id ).take
    # we can get all pages based on the charity id - rails makes it so we can access it like an attribute
    @pages = @charity.pages
    # same applies for content - notice one-to-one (has_one) associations are not pluralised
    @content = @page.content
  end

  def new
    # we always fetch a charity based on the domain in the url
    @charity = Charity.where( domain: params[ :charity_id ] ).take

    # make sure this admin is auth and is his own charity
    if session[ :auth ] and session[ :user_id ] == @charity.user_id
      @page = @charity.pages.build
      @content = @page.build_content
    else
      redirect_to @charity
    end
  end

  def create
    if session[ :auth ] and session[ :user_id ] == @charity.user_id
      @charity = Charity.where( domain: params[ :charity_id ] ).take
      @page = @charity.pages.create( get_page_params )
      @content = @page.create_content( get_content_params )

      if @page.save
        # redirects to a url generated based on the charity and the page in the charity
        # eg. charity = catactiontrust, page = donations ---> url = charityhosting.ie/charities/catactiontrust/donations
        redirect_to charity_page_path( @charity, @page )
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  def edit
    @charity = Charity.where( domain: params[ :charity_id ] ).take

    if session[ :auth ] and session[ :user_id ] == @charity.user_id
      # get the charity's page to edit
      @page = @charity.pages.where( title: params[ :id ] ).take
      # get the page's content to edit
      @content = @page.content
    else
      redirect_to @charity
    end
  end

  def update
    @charity = Charity.where( domain: params[ :charity_id ] ).take

    if session[ :auth ] and session[ :user_id ] == @charity.user_id
      # we need to get the charity's page we're trying to update
      @page = @charity.pages.where( title: params[ :id ] ).take
      # get the page's content to update
      @content = @page.content

      if @page.update_attributes get_page_params and @content.update_attributes get_content_params
        redirect_to charity_page_path( @charity, @page )
      else
        render "edit"
      end
    else
      redirect_to @charity
    end
  end

  def destroy
    charity = Charity.where( domain: params[ :charity_id ] ).take

    if session[ :auth ] and session[ :user_id ] == @charity.user_id
      page = Page.where( title: params[ :id ] ).take

      # will change this to some destroy_enabled attribute
      if page.title != "index"
        # removes page from its table and any link it has on other tables (normal form)
        page.destroy
      end
    end

    redirect_to charity
  end

  private
  def get_page_params
    params[ :page ] ? params[ :page ].permit( :title ) : ""
  end

  def get_content_params
    params.require( :content ).permit( :content_src )
  end
end
