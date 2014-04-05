class RequestsController < ApplicationController
  def index
    # only admin can access requests
    if is_admin
      @admin = User.get_admin
      @requests_pending = Request.where( approved: false )
      @requests_approved = Request.where( approved: true )
      @charities = Charity.all
    else
      # if not auth, login
      redirect_to login_path( :return => request.url )
    end
  end

  def show
    if is_admin
      @request = Request.find( params[ :request_id ] )

      # check to see if there's a conflict with email addresses in the request
      flash[ :email ] = "No two charities can have the same email (" + @request.email + ")" unless Charity.find_by_email( @request.email ).nil?
    else
      redirect_to login_path( :return => request.url )
    end
  end

  def new
    @request = Request.new
  end

  def create
    @request = Request.create( get_request_params )
    @request.approved = false # init the request as not approved

    if @request.valid? and @request.save!

      # email admin and user of new request
      RequestMailer.request_email( @request ).deliver
      RequestMailer.confirm_request_email( @request ).deliver

      redirect_to charities_path, flash: { overhead: "Your request has been sent" }
    else
      render 'new'
    end
  end

  def edit
    if is_admin
      @request = Request.find( params[ :request_id ] )

      if @request.approved
        flash[ :overhead ] = "Cannot edit approved requests"
        redirect_to admin_request_path( @request )
      end
    else
      redirect_to login_path( :return => request.url )
    end
  end

  def update
    if is_admin
      @request = Request.find( params[ :request_id ] )

      if !@request.approved
        @request.update_attributes( get_request_params )
        flash[ :overhead ] = "Request updated successfully"
      else
        flash[ :overhead ] = "Cannot edit approved requests"
      end

      redirect_to admin_request_path( @request )
    else
      redirect_to login_path( :return => request.url )
    end
  end

  def destroy
    if is_admin
      @request = Request.find( params[ :request_id ] )
      @request.destroy
    end

    redirect_to :back
  end

  #approves a request for a new charity be created
  def approve
    if is_admin
      @request = Request.find( params[ :approve ][ :request_id ] )
      # get any additional information the admin provided
      @info = params[ :approve ][ :info ]

      # generate a secure token for this request that only the user and admin will know
      token = SecureRandom.hex( 24 )
      @request.update_attributes( approved: true, approval_token: token )

      RequestMailer.approve_request( @request, @info ).deliver
      flash[ :overhead ] = "Request #" + @request.id.to_s + " approved."
    else
      flash[ :overhead ] = "You are not authorized to approve requests."
    end

    redirect_to admin_requests_path
  end

  # rejects requests
  def reject
    if is_admin
      @request = Request.find( params[ :reject ][ :request_id ] )
      # get reason for rejection
      @reason = params[ :reject ][ :reason ]

      @request.update_attributes( approved: false )

      #RequestMailer.reject_request( @request, @reason ).deliver
      flash[ :overhead ] = "Request #" + @request.id.to_s + " rejected."
    else
      flash[ :overhead ] = "You are not authorized to reject requests."
    end

    redirect_to admin_requests_path
  end

  private

  def is_admin
    session[ :auth ] and session[ :user_id ] == User.get_admin.id
  end

  def get_request_params
    params.require( :request ).permit( :domain, :org_name, :org_address, :org_tel, :charity_number, :charity_number_verified, :email, :template )
  end
end
