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