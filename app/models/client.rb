class Client < ApplicationRecord
  has_many :buildings, dependent: :destroy
  has_many :client_custom_fields, dependent: :destroy
end
