require 'odoo/import'

include Odoo::Import

namespace :import do
  desc 'imports once all the delivery orders'
  task delivery_all: :environment do
    import_all()
  end

  desc 'imports once 1 devlivery order with id'
  odoo_id = ENV['odoo_id']
  task delivery: :environment do
    import_delivery(odoo_id.to_i)
  end

  desc 'imports once all the delivery orders'
  task delivery_loop: :environment do
    loop do
      import_all()
      sleep 2
    end
  end

  desc 'change the state of the order'
  task process: :environment do
    odoo_id = ENV['odoo_id']
    carrier_tracking_ref = ENV['carrier_tracking_ref']
    puts "the odoo id is #{odoo_id} with reference #{carrier_tracking_ref}"
    process_delivery_order(odoo_id, carrier_tracking_ref)
  end
end
