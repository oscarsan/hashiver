require "xmlrpc/client"

module Odoo
  module Import
    def import_delivery
      Rails.logger.tagged('IMPORTING') do
        begin
          begin

            url = "http://localhost:8069"
            db = "test"
            username = "oscarsanhueza@gmail.com"
            password = "oscar"

            common = XMLRPC::Client.new2("#{url}/xmlrpc/2/common")
            uid = common.call('authenticate', db, username, password, {})
            models = XMLRPC::Client.new2("#{url}/xmlrpc/2/object").proxy

            #get all sales orders ids which are assigned and outgoing
            ids = models.execute_kw(db, uid, password,
                'stock.picking', 'search',
                [[['picking_type_code','=','outgoing']]])

            #get all product names
            delivery_orders = models.execute_kw(db, uid, password,
                'stock.picking', 'read',
                [ids], {'fields': ['name', 'state', 'display_name', 'origin', 'pack_operation_ids']})

            puts delivery_orders


            delivery_orders.each do |delivery_order|
              d = DeliveryOrder.find_or_create_by(odoo_id: delivery_order["id"])
              delivery_order.delete("id")
              d.update_attributes(delivery_order)
            end


          rescue StandardError
            Rails.logger.error '    Error receiving data, trying to recover'
            raise
          end
        rescue
          Rails.logger.error "    ! Error importing"
          Rails.logger.error $!.backtrace
          raise
        end
      end
    end

    def process_delivery_order(odoo_id)
      begin
        url = "http://localhost:8069"
        db = "test"
        username = "oscarsanhueza@gmail.com"
        password = "oscar"

        common = XMLRPC::Client.new2("#{url}/xmlrpc/2/common")
        uid = common.call('authenticate', db, username, password, {})
        models = XMLRPC::Client.new2("#{url}/xmlrpc/2/object").proxy

        result = models.execute_kw(
                db, uid, password,
                'stock.picking', 'do_new_transfer', [odoo_id.to_i])

      rescue StandardError
        Rails.logger.error '    Error receiving data, trying to recover'
      end

    end
  end
end
