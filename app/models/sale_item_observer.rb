class SaleItemObserver < ActiveRecord::Observer
  def after_create(sale_item)
    item = Item.first(:sku=>sale_item.sku)
    item.users.each do |user|
      # TODO if user has instant alerts turned on deliver right away
      Nofity.sale_email(user, [item]).deliver
    end
  end
end
