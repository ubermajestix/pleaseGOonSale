Fabricator(:user) do
  email { Fabricate.sequence(:email) { |i| "#{Faker::Name.first_name}@example.com" } }
  confirmed_at Time.now
  password 'boom1!'
end

Fabricator(:item) do
  name { Fabricate.sequence(:name) { |i| "item-#{i}" } }
  sku { Fabricate.sequence :sku, 111111111 }
  image_url "http://images.somestore.example.com/"
  raw_price rand(400).to_s 
  after_build{|item| item.store_url = "http://somestore.example.com?id=#{item.sku}"}
  after_build{|item| item.image_url = "http://images.somestore.example.com/#{item.sku}.jpg"}
end

Fabricator(:sale_item) do
  name { Fabricate.sequence(:name) { |i| "sale_item-#{i}" } }
  sku { Fabricate.sequence :sku, 222222222 }
  raw_original_price rand(400).to_s
  after_build{|item| item.raw_sale_price = (item.raw_original_price.to_f * 0.25).to_s }
  after_build{|item| item.store_url = "http://somestore.example.com?id=#{item.sku}"}
  after_build{|item| item.image_url = "http://images.somestore.example.com/#{item.sku}.jpg"}
end