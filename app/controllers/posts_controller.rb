class PostsController < ApplicationController
  def index
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @pages = @charity.pages

    @page_break_num = 9
    @posts = Post.all.paginate( page: params[ :page ], per_page: @page_break_num )
  end

  def show
    get_charity_info
    @post = Post.find( params[ :id ] )
    @user = User.find( @post.user_id )
  end

  def new
    get_charity_info

    if is_auth
      @post = @charity.posts.build
    else
      redirect_to charity_posts_path( @charity )
    end
  end

  def create
    get_charity_info 

    if is_auth
      @post = @charity.posts.create( get_post_params )
      @post.user_id = session[ :user_id ]

      if @post.valid? and @post.save
        redirect_to charity_post_path( @charity, @post ), flash: { overhead: "Post created successfully" }
      else
        render 'new', flash: { overhead: "Post creation failed." }
      end
    else
      redirect_to charity_posts_path( @charity )
    end
  end

  def edit
    get_charity_info

    if is_auth
      @post = @charity.posts.find( params[ :id ] )
    else
      redirect_to charity_posts_path( @charity ), flash: { overhead: "You are not permitted to do that." }
    end
  end

  def update
    get_charity_info

    if is_auth
      @post = @charity.posts.find( params[ :id ] )
      @post.update_attributes( get_post_params )

      flash[ :overhead ] = "Post successfully updated"
    else
      flash[ :overhead ] = "You are not permitted to do that."
    end

    redirect_to charity_post_path( @charity, @post )
  end

  def destroy
    get_charity_info
    @post = @charity.posts.find( params[ :id ] )

    if is_auth
      if @post.destroy
        flash[ :overhead ] = "Post successfully deleted."
      else
        flash[ :overhead ] = "Post deletion failed."
      end

      redirect_to charity_posts_path( @charity )
    else
      redirect_to charity_post_path( @charity, @post ), flash: { overhead: "You are not permitted to do that." }
    end
  end

  private

  def get_charity_info
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @pages = @charity.pages
  end
  
  def is_auth
    ( session[ :auth ] and session[ :user_id ] == @charity.user_id )
  end

  def get_post_params
    params.require( :post ).permit( :title, :summary, :post_content )
  end
end
