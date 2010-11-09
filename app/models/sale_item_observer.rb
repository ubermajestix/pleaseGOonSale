class SaleItemObserver < ActiveRecord::Observer
  
  def after_create(sale_item)
    item = Item.where(:sku=>sale_item.sku).first
    if item
      item.users.each do |user|
        # TODO if user has instant alerts turned on deliver right away
         Notify.sale_email(user, [sale_item]).deliver
      end
    end
  end
  
end
