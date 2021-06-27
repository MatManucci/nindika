# frozen_string_literal: true

module WishlistItems
  class Create < Actor
    input :user, type: User
    input :item_id, type: String

    output :wishlist_item, type: WishlistItem

    def call
      self.wishlist_item = user.wishlist_items.new(item_id: item_id)

      fail!(error: :invalid_wishlist) unless wishlist_item.save
    end
  end
end
