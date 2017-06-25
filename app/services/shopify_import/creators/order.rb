module ShopifyImport
  module Creators
    class Order < ShopifyImport::Creators::Base
      def save!
        Spree::Order.transaction do
          @spree_order = create_spree_order
          assign_spree_order_to_data_feed
          @spree_order.update_columns(order_timestamps)
        end
      end

      private

      def create_spree_order
        order = Spree::Order.new(user: user)
        order.assign_attributes(order_attributes)
        order.save!
        order
      end

      def user
        parser.user
      end

      def order_attributes
        parser.order_attributes.select { |a| Spree::Order.attribute_method?(a) }
      end

      def order_timestamps
        parser.order_timestamps
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Orders::BaseData.new(shopify_order)
      end

      def shopify_order
        @shopify_order ||= ShopifyAPI::Order.new(data_feed)
      end

      def assign_spree_order_to_data_feed
        @shopify_data_feed.update!(spree_object: @spree_order)
      end
    end
  end
end
