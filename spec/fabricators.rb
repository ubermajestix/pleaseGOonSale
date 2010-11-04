Fabricator(:user) do
  name Faker::Name.name
  email Faker::Internet.email #{ Fabricate.sequence(:email) { |i| "user#{i}@example.com" } }
  has_confirmed true
  password 'boom1!'
end

Fabricator(:item) do
  name { Fabricate.sequence(:name) { |i| "item-#{i}" } }
  sku { Fabricate.sequence :sku, 111111111 }
  raw_price rand(400).to_s 
end

Fabricator(:sale_item) do
  name { Fabricate.sequence(:name) { |i| "sale_item-#{i}" } }
  sku { Fabricate.sequence :sku, 222222222 }
  raw_original_price rand(400).to_s
  after_build{|item| item.raw_sale_price = (item.raw_original_price.to_f * 0.25).to_s }
end