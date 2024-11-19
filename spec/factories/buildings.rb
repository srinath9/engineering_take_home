FactoryBot.define do
  factory :building do
    address { "123 Beauregard St" }
    association :client

    trait :with_custom_values do
      after(:create) do |building|
        building.client.custom_fields.each do |custom_field|
          create(:building_custom_value,
            building: building,
            custom_field: custom_field,
            value: Faker::Lorem.word)
        end
      end
    end
  end
end
