class ChargesController < ApplicationController
  def new
  	@charity = Charity.find_by_domain( params[ :charity_id ] )
  	@pages = @charity.pages 
  end

  def create
    # Amount in cents
    @charity = Charity.find_by_domain( params[ :charity_id ] )
    @amount = params[ :stripeAmount ]

    @donation = @charity.donations.create( amount: ( params[ :stripeAmount ].to_f / 100 ), token: params[ :stripeToken ], email: params[ :stripeEmail ] )

    if @donation.save!
      customer = Stripe::Customer.create(
        :email => params[ :stripeEmail ],
        :card  => params[ :stripeToken ]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => "Charity hosting donation",
        :currency    => 'EUR'
      )

      flash[ :success ] = true
      flash[ :overhead ] = "Transaction successful."
    else
      flash[ :overhead ] = "Transaction failed."
    end

    redirect_to :back

  rescue Stripe::CardError => error
    redirect_to :back, flash: { overhead: error }
  end
end
