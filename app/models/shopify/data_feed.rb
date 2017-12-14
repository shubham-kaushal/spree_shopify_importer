module Shopify
  class DataFeed < ApplicationRecord
    belongs_to :spree_object, polymorphic: true, required: false, inverse_of: false
    belongs_to :parent, class_name: 'Shopify::DataFeed', required: false, inverse_of: :children
    has_many :children, class_name: 'Shopify::DataFeed', foreign_key: :parent_id, dependent: :destroy, inverse_of:
      :parent

    validates :shopify_object_id, :shopify_object_type, presence: true
    validates :shopify_object_id, uniqueness: { scope: :shopify_object_type }
    validates :spree_object_id, uniqueness: { scope: :spree_object_type }, allow_nil: true
  end
end
