class SaleItemObserver < ActiveRecord::Observer
  
  # def after_create(sale_item)
  #   item = Item.where(:sku=>sale_item.sku).first
  #   puts "="*45
  #   puts "observer item: #{item.inspect}"
  #   puts "="*45
  #   if item
  #     item.users.each do |user|
  #       puts "="*45
  #       puts "observer user: #{user.inspect}"
  #       puts "="*45
  #       # TODO if user has instant alerts turned on deliver right away
  #        Notify.sale_email(user, [sale_item]).deliver
  #     end
  #   end
  # end
  
end
