module SpreeLocalTax
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)
      # def add_javascripts
      #   append_file 'app/assets/javascripts/store/all.js', "//= require store/spree_local_tax\n"
      #   append_file 'app/assets/javascripts/admin/all.js', "//= require admin/spree_local_tax\n"
      # end

      # def add_stylesheets
      #   inject_into_file 'app/assets/stylesheets/store/all.css', " *= require store/spree_local_tax\n", :before => /\*\//, :verbose => true
      #   inject_into_file 'app/assets/stylesheets/admin/all.css', " *= require admin/spree_local_tax\n", :before => /\*\//, :verbose => true
      # end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_local_tax'
      end

      def create_initializer_file
        create_file "config/initializers/zip_tax.rb", "# Add your ZipTax Api key. ZipTax.key = 'yourkey'"
      end

      def copy_initializer_file
        copy_file "initializer.rb", "config/initializers/zip_tax.rb"
      end

      def run_migrations
         res = ask 'Would you like to run the migrations now? [Y/n]'
         if res == '' || res.downcase == 'y'
           run 'bundle exec rake db:migrate'
         else
           puts 'Skiping rake db:migrate, don\'t forget to run it!'
         end
      end
    end
  end
end
