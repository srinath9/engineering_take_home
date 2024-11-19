FactoryBot.define do
  factory :client_custom_field do
    name { 'Custom Field' }
    field_type { :string }
    association :client

    trait :list_type do
      field_type { :list }
      enum_options { [ "Option 1", "Option 2" ] }
    end

    trait :number_type do
      field_type { :number }
    end
  end
end
