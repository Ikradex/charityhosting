class PostsController < ApplicationController
  def index
  end

  def show
    @post = Post.where( title: params[ :id ] ).take
  end

  def new
    if session[ :auth ]
      
    else
        render 'index'
    end
  end

  def create
    render text: params[ :post ].inspect
    
=begin  @post = Post.new( get_post_params )

    if @post.save
        redirect_to @post
    else 
        render 'new'
    end
=end

    if session[ :userid ] and @post.save
        redirect_to @post
    else 
        render 'new'
    end
  end

  def edit
  end

  private 
    def get_post_params
        params.require( :post ).permit( :title, :content )
    end
end
