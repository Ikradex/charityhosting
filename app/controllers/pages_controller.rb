class PagesController < ApplicationController
  def show
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @page = @charity.pages.find_by_title( params[ :page_id ] )
    @pages = @charity.pages
    @content = @page.content
  end

  def new
    # we always fetch a charity based on the domain in the url
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @pages = @charity.pages
    @user = User.find( session[ :user_id ] ) unless session[ :auth ].blank?

    # make sure this admin is auth and is his own charity
    if @user.present? && @charity.is_admin( @user )
        @page = @charity.pages.build
        @content = @page.build_content
    else
      flash[ :overhead ] = "You are not permitted to do that."
    end

    redirect_to @charity
  end

  def create
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @user = User.find( session[ :user_id ] ) unless session[ :auth ].blank?
    
    if @user.present? && @charity.is_admin( @user )
      @page = @charity.pages.create( get_page_params )
      @content = @page.create_content( get_content_params )

      if @page.save
        redirect_to charity_page_path( @charity, @page ), flash: { overhead: "Page creation successful" }
      else
        flash[ :overhead ] = "Page creation failed."
        render 'new'
      end
    else
      flash[ :overhead ] = "You are not permitted to do that."
      render 'new'
    end
  end

  def edit
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @pages = @charity.pages

    if session[ :auth ] and session[ :user_id ] == @charity.user_id
      # get the charity's page to edit
      @page = @charity.pages.find_by_title( params[ :id ] )
      # get the page's content to edit
      @content = @page.content
    else
      redirect_to @charity
    end
  end

  def update
    @charity = Charity.find_by_domain( params[ :charity_id ] )

    if session[ :auth ] and session[ :user_id ] == @charity.user_id
      # we need to get the charity's page we're trying to update
      @page = @charity.pages.find_by_title( params[ :id ] )
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
    charity = Charity.where( domain: params[ :charity_id ] )

    if session[ :auth ] and session[ :user_id ] == @charity.user_id
      page = Page.find_by_title( params[ :id ] )

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