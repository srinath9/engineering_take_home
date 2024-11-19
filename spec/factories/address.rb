# spec/factories/address.rb
FactoryBot.define do
    factory :address do
      address1 { "891 Lesch Hills" }
      address2 { "Apt. 940" }
      city { "North Gwynville" }
      state { "KS" }
      country { "USA" }
      postal_code { "39073-3920" }
    end
end