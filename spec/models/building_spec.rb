# spec/models/building_spec.rb
require 'rails_helper'

RSpec.describe Building, type: :model do
  # Testing the associations
  it { should belong_to(:client) }
  it { should belong_to(:address) }
  it { should have_many(:building_custom_fields).dependent(:destroy) }

end