require 'rails_helper'

RSpec.describe BuildingCustomField, type: :model do
  # Testing the associations
  it { should belong_to(:building) }
  it { should belong_to(:client_custom_field) }

  # Testing the field_name method
  describe '#field_name' do
    it 'returns the name of the associated client custom field' do
      # Create a ClientCustomField instance with a name
      client_custom_field = ClientCustomField.create(name: "Test Field")

      # Create a BuildingCustomField instance associated with the ClientCustomField
      building_custom_field = BuildingCustomField.create(client_custom_field: client_custom_field)

      expect(building_custom_field.field_name).to eq("Test Field")
    end

    it 'returns nil if there is no associated client custom field' do
      # Create a BuildingCustomField instance without an associated ClientCustomField
      building_custom_field = BuildingCustomField.new(client_custom_field: nil)

      expect(building_custom_field.field_name).to be_nil
    end
  end
end