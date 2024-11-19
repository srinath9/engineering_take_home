FactoryBot.define do
    factory :building_client_custom_field do
      value { "Sample Value" }

      transient do
        client { create(:client) }
      end


      building { association :building, client: client }
      client_custom_field { association :client_custom_field, client: client }

      trait :number_value do
        value { "123" }
        client_custom_field { association :client_custom_field, :number_type, client: client }
      end

      trait :string_value do
        value { "Some string" }
        client_custom_field { association :client_custom_field, client: client }
      end

      trait :list_value do
        value { "Option 1" }
        client_custom_field { association :client_custom_field, :list_type, client: client }
      end
    end
  end
