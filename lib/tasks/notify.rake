desc "notify users they have items on sale"
task :notify => :environment do
  User.find_each do |user|
    # TODO named scope this
    sale_items = user.items.collect{|i| i.sale_item}.uniq.compact
    Notify.sale_email(user,sale_items).deliver if sale_items.any?
  end
end