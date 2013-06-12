module SpreeLocalTax
  class Configuration < Spree::Preferences::Configuration
    preference :avalara_username, :string
    preference :avalara_password, :string
    preference :avalara_endpoint, :string, default: 'https://rest.avalara.net'
  end
end
