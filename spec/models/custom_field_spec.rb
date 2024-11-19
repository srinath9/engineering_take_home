require 'rails_helper'

RSpec.describe ClientCustomField, type: :model do
  describe 'associations' do
    it { should belong_to(:client) }
    it { should have_many(:building_custom_fields) }
  end

  describe 'validations' do
    it { should validate_presence_of(:field_type) }

    describe 'enums' do
      it 'defines the correct enum values' do
        expect(ClientCustomField.field_types).to eq({"number" => 1, "freeform" => 2, "enum_field" => 3})
      end
  
  
      it 'allows setting field_type using symbols' do
        custom_field = ClientCustomField.new(field_type: :number)
        expect(custom_field.field_type).to eq("number")
      end
  
  
      it 'allows setting field_type using strings' do
        custom_field = ClientCustomField.new(field_type: "freeform")
        expect(custom_field.field_type).to eq("freeform")
      end
  
      it 'raises an ArgumentError for invalid field_type' do
        expect {
          ClientCustomField.new(field_type: "invalid_type")
        }.to raise_error(ArgumentError, "'invalid_type' is not a valid field_type")
      end
    end

  end
end
