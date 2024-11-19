class ClientCustomField < ApplicationRecord
  belongs_to :client
  has_many :building_custom_fields, dependent: :destroy

  enum field_type: { number: 1, freeform: 2, enum_field:3 }

  validates :field_type, presence: true
end
