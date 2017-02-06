require 'odoo/import'

include Odoo::Import

namespace :import do
  desc 'imports once all the delivery orders'
  task delivery: :environment do
    import_delivery()
  end

  desc 'imports once all the delivery orders'
  task product_loop: :environment do
    loop do
      import_delivery()
      sleep 2
    end
  end

  desc 'change the state of the order'
  task process: :environment do
    odoo_id = ENV['odoo_id']
    puts "the odoo id is #{odoo_id}"
    process_delivery_order(odoo_id)
  end
end
