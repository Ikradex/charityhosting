class PagesController < ApplicationController
	def show
		id = params[ :id ] ? params[ :id ] : params[ :page_id ] ? params[ :page_id ] : "index"
		@charity = Charity.where( domain: params[ :charity_id ] ).take
		@page = @charity.pages.where( title: id ).take
		@pages = @charity.pages
		@content = @page.content
	end 

	def new
		@charity = Charity.where( domain: params[ :charity_id ] ).take

		if session[ :auth ] and session[ :user_id ] == @charity.user_id
			@page = @charity.pages.build
			@content = @page.build_content
		else 
			redirect_to @charity
		end
	end

	def create
		if session[ :auth ]
			@charity = Charity.where( domain: params[ :charity_id ] ).take
			@page = @charity.pages.create( get_page_params )
			@content = @page.create_content( get_content_params )

			if @page.save
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
		@page = @charity.pages.where( title: params[ :id ] ).take
		@content = @page.content
	end

	def update
		@charity = Charity.where( domain: params[ :charity_id ] ).take
		@page = @charity.pages.where( title: params[ :id ] ).take
		@content = @page.content

		if @page.update_attributes get_page_params and @content.update_attributes get_content_params
			redirect_to charity_page_path( @charity, @page )
		else
			render "edit"
		end
	end

	def destroy
		charity = Charity.where( domain: params[ :charity_id ] ).take
		page = Page.where( title: params[ :id ] ).take

		if page.title != "index"
			page.destroy
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
