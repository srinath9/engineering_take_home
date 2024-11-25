# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear out existing data to avoid duplication

require 'faker'

BuildingCustomField.delete_all
Building.delete_all
Address.delete_all
ClientCustomField.delete_all
Client.delete_all

# Helper method to create addresses
def create_address
  Address.create!(
    address1: Faker::Address.street_address,
    address2: Faker::Address.secondary_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    country: 'USA',
    postal_code: Faker::Address.zip_code
  )
end

# Sample client data
clients_data = [
    {
      "name": "Urban Realty Group",
      "custom_fields": [
        {
          "name": "Year Established",
          "field_type": 1
        },
        {
          "name": "Number of Properties",
          "field_type": 1
        },
        {
          "name": "Specialty",
          "field_type": 3
        }
      ]
    },
    {
      "name": "Coastal Property Management",
      "custom_fields": [
        {
          "name": "Year Established",
          "field_type": 1
        },
        {
          "name": "Average Rental Price",
          "field_type": 1
        },
        {
          "name": "Property Type",
          "field_type": 3
        }
      ]
    },
    {
      "name": "Mountain View Estates",
      "custom_fields": [
        {
          "name": "Year Established",
          "field_type": 1
        },
        {
          "name": "Number of Agents",
          "field_type": 1
        },
        {
          "name": "Featured Listings",
          "field_type": 2
        }
      ]
    },
    {
      "name": "Downtown Commercial Properties",
      "custom_fields": [
        {
          "name": "Year Established",
          "field_type": 1
        },
        {
          "name": "Square Footage",
          "field_type": 1
        },
        {
          "name": "Property Type",
          "field_type": 3
        }
      ]
    },
    {
      "name": "Greenfield Residential Services",
      "custom_fields": [
        {
          "name": "Year Established",
          "field_type": 1
        },
        {
          "name": "Average Home Price",
          "field_type": 1
        },
        {
          "name": "Client Satisfaction Rating",
          "field_type": 1
        }
      ]
    }
  ]


# Enum values for custom fields
enum_values = {
  "Specialty" => ["Residential", "Commercial", "Industrial"],
  "Property Type" => ["Apartment", "Condo", "Townhouse", "Office", "Retail", "Warehouse"]
}

# Create clients and associated custom fields
clients_data.each_with_index do |client_data, index|
  client = Client.create!(name: client_data[:name])

  # Create ClientCustomFields and store them for reference
  custom_fields = client_data[:custom_fields].map do |field|
    enum_options = enum_values[field[:name]]&.to_json
    ClientCustomField.create!(name: field[:name], field_type: field[:field_type], client: client, enum_options: enum_options)
  end

  3.times do |i|
    building = Building.create!(client: client, address: create_address)

    # Create BuildingCustomField
    custom_fields.each do |custom_field|
      case custom_field.name
      when "Year Established"
        BuildingCustomField.create!(building: building, client_custom_field: custom_field, value: rand(2000..2023).to_s)
      when "Number of Properties"
        BuildingCustomField.create!(building: building, client_custom_field: custom_field, value: rand(10..200).to_s)
      when "Average Rental Price"
        BuildingCustomField.create!(building: building, client_custom_field: custom_field, value: rand(1500..3000).to_s) if client_data[:name] == "Coastal Property Management"
      when "Number of Agents"
        BuildingCustomField.create!(building: building, client_custom_field: custom_field, value: rand(5..30).to_s) if client_data[:name] == "Mountain View Estates"
      when "Featured Listings"
        BuildingCustomField.create!(building: building, client_custom_field: custom_field, value: "Luxury Condo, 3 Bedroom House") if client_data[:name] == "Mountain View Estates"
      when "Square Footage"
        BuildingCustomField.create!(building: building, client_custom_field: custom_field, value: "#{rand(1000..10000)} sq ft") if client_data[:name] == "Downtown Commercial Properties"
      when "Client Satisfaction Rating"
        BuildingCustomField.create!(building: building, client_custom_field: custom_field, value: "#{rand(3..5)} out of 5") if client_data[:name] == "Greenfield Residential Services"
      end
    end

    # Add enum field values where applicable
    if enum_values.keys.any? { |key| custom_fields.map(&:name).include?(key) }
      enum_field_name = custom_fields.find { |cf| enum_values.keys.include?(cf.name) }&.name
      if enum_field_name
        BuildingCustomField.create!(building: building, client_custom_field: ClientCustomField.find_by(name: enum_field_name, client: client), value: enum_values[enum_field_name].sample)
      end
    end
  end
end

puts "Seeding completed successfully!"

