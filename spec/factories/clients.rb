FactoryBot.define do
  factory :client do
    name { "Default Client" }

    trait :with_buildings do
      after(:create) do |client|
        address = create(:address)
       

        # buildings = build_list(:building, 3, client: client, address: address)
        buildings = build_list(:building, 3, client: client, address: address)
        buildings.each(&:save!)
      end
    end

    trait :with_custom_fields do
      after(:create) do |client|
        create(:client_custom_field, client: client, name: "Custom Field 1", field_type: "number")
        create(:client_custom_field, client: client, name: "Custom Field 2", field_type: "number")
        create(:client_custom_field, client: client, name: "Custom Field 3", field_type: "number")
      end
    end

    trait :with_buildings_and_custom_fields do
      with_buildings
      with_custom_fields
    end

    trait :with_buildings_and_custom_values do
      with_buildings
      with_custom_fields
      after(:create) do |client|
        custom_fields = client.client_custom_fields
        client.buildings.each do |building|
          custom_fields.each do |custom_field|
            create(:building_custom_field, building: building, client_custom_fields: custom_field, value: Faker::Lorem.word)
          end
        end
      end
    end
  end
end
