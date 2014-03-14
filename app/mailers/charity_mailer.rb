class CharityMailer < ActionMailer::Base
  default from: "ikradex@gmail.com"

  def welcome_email( user, charity )
  	@charity = charity
  	@user = user
  	@name = user.f_name + " " + user.l_name
  	@url = "http://localhost/login"

  	mail( to: @charity.email, subject: "Welcome to Charity Hosting" )
  end
end
