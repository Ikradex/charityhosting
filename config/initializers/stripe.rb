Rails.configuration.stripe = {
  :publishable_key => "pk_test_rcnc3BbcNcX0Q5NI1RQjofu0",
  :secret_key      => "sk_test_IkSnUfTGAExJjEuuxVeNqW1o"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]