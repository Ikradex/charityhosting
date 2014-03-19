class ChargesController < ApplicationController
  def new
  	@charity = Charity.find_by_domain( params[ :charity_id ] )
  	@pages = @charity.pages 
  end

  def create
    # Amount in cents
    @amount = params[ :amount ]

    customer = Stripe::Customer.create(
      :email => 'example@stripe.com',
      :card  => params[ :stripeToken ]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => "Donation",
      :currency    => 'EUR'
    )

  rescue Stripe::CardError => error
    flash[ :overhead ] = error.message
    redirect_to charges_path
  end
end
