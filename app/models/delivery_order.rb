require 'odoo/import'

class DeliveryOrder < ApplicationRecord
    include Odoo::Import
    def process_order
      process_delivery_order(self['odoo_id'], self['carrier_tracking_ref'])
      return true
    end

    def update_model
      import_delivery([self['odoo_id'].to_i])
      return true
    end

end
