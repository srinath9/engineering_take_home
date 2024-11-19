class Building < ApplicationRecord
  belongs_to :client
  belongs_to :address
  has_many :building_custom_fields, dependent: :destroy
end
