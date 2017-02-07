require "xmlrpc/client"

module Odoo
  module Import

    URL = "http://localhost:8069"
    DB = "test"
    USERNAME = "oscarsanhueza@gmail.com"
    PASSWORD = "oscar"

    def import_all()
      begin
        common = XMLRPC::Client.new2("#{URL}/xmlrpc/2/common")
        uid = common.call('authenticate', DB, USERNAME, PASSWORD, {})
        models = XMLRPC::Client.new2("#{URL}/xmlrpc/2/object").proxy
        #get all sales orders ids which are assigned and outgoing
        ids = models.execute_kw(DB, uid, PASSWORD,
              'stock.picking', 'search',
              [[['picking_type_code','=','outgoing']]])
        import_delivery(ids)
      rescue StandardError
        Rails.logger.error '    Error receiving data, trying to recover'
        raise
      end
    end

    def import_delivery(odoo_ids)
      begin

          puts odoo_ids
          common = XMLRPC::Client.new2("#{URL}/xmlrpc/2/common")
          uid = common.call('authenticate', DB, USERNAME, PASSWORD, {})
          models = XMLRPC::Client.new2("#{URL}/xmlrpc/2/object").proxy

          delivery_orders = models.execute_kw(DB, uid, PASSWORD,
              'stock.picking', 'read',
              [odoo_ids], {'fields': ['name', 'state', 'display_name', 'origin', 'pack_operation_ids']})
          puts delivery_orders
          delivery_orders.map { |e|
            d = DeliveryOrder.find_or_create_by(odoo_id: e["id"])
            e.delete("id")
            d.update_attributes(e)
          }
        rescue StandardError
          Rails.logger.error '    Error receiving data, trying to recover'
          raise
        end
    end

    def process_delivery_order(odoo_id)
      begin

        common = XMLRPC::Client.new2("#{URL}/xmlrpc/2/common")
        uid = common.call('authenticate', DB, USERNAME, PASSWORD, {})
        models = XMLRPC::Client.new2("#{URL}/xmlrpc/2/object").proxy

        result = models.execute_kw(
                DB, uid, PASSWORD,
                'stock.picking', 'do_new_transfer', [odoo_id.to_i])

      rescue StandardError
        Rails.logger.error '    Error receiving data, trying to recover'
      end

    end
  end
end
