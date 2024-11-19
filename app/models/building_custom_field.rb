class BuildingCustomField < ApplicationRecord
  belongs_to :building
  belongs_to :client_custom_field

  # Custom method to fetch the name from the associated client custom field
  def field_name
    client_custom_field&.name
  end
end
