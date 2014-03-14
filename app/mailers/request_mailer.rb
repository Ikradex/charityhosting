class RequestMailer < ActionMailer::Base
  default from: "ikradex@gmail.com"

  def request_email( request ) 
    @request = request

    mail( to: User.get_admin.email, subject: "Request: " + @request.org_name )
  end

  def confirm_request_email( request )
    @request = request

    mail( to: request.email, subject: "Request sent" )
  end

  def approve_request( request, info )
    @request = request
    @info = info

    mail( to: request.email, subject: "Request: " + @request.org_name + " approved!" )
  end

  def reject_request( request, reason )
    @request = request
    @reason = reason

    mail( to: request.email, subject: "Request: " + @request.org_name + " rejected." )
  end
end