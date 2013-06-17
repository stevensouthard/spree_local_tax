module SpreeLocalTax
  class Engine < Rails::Engine
    engine_name 'spree_local_tax'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "spree.environment.local_tax", before: :load_config_initializers do |app|
      require 'spree/local_tax/configuration'
      SpreeLocalTax::Config = SpreeLocalTax::Configuration.new
    end

    initializer 'spree.register.local_tax', :after => "spree.register.calculators" do |app|
       app.config.spree.calculators.tax_rates << Spree::Calculator::LocalTax
       app.config.spree.calculators.tax_rates << Spree::Calculator::ZipcodeTax
       app.config.spree.calculators.tax_rates << Spree::Calculator::AvalaraTax
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
