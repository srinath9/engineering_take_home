require 'rails_helper'

RSpec.describe Client, type: :model do

  describe 'associations' do
    it { should have_many(:buildings) }
    it { should have_many(:client_custom_fields) }
  end
end
