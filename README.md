SpreeLocalTax
=============

Local tax calculation (i.e. state based for US taxation) for Spree Commerce.

Design goals:  

* Inherit from DefaultTax
* Taxable amount is calculated as: item total.
* Allow for matching by zip code or use Spree standard DefaultTax for a flat rate.
* No modifications to existing tax calculation logic: all logic contained within new calculator

Example
=======

Run `bundle exec rails g spree_local_tax:install` to add & run the DB migration for SQL based local tax calculation (currently the only supported method).  

After installation, a new tax calculator will be available under Configuration --> Tax Rates.  

Tax Rates
=========

Taxes are entered into the newly created, spree_local_tax table. This acts asn an override table. If a zip code
is found to match, and the "local" tax is set, this rate will be used rather than the state, country, default tax
supplied by typical spree implementation.

Configuration
=============
Lets say you want to use flat rate for the great state of Georgia and zip codes for tax in Texas.
Create a Zone for GA. Create a Tax Rate for that Zone use DefaultTax, set it to 0.01.

Create a Zone for TX. Create a new Tax Rate for that Zone. Use LocalTax calculator, and set the 
rate to 0.05 (or whatever you want your TX fallback rate to be). Then for 75209 (in Dallas) set the 
local column to 0.07. Rinse, Repeat for each overriding zip.

Initial version:
Copyright (c) 2012 Michael Bianco (@iloveitaly), released under the New BSD License
Changes from 1.3: Eric Winter @ehwinter

