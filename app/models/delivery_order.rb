require 'odoo/import'

class DeliveryOrder < ApplicationRecord
    include Odoo::Import
    def process_order
      process_delivery_order(self['odoo_id'])
      return true
    end

end
