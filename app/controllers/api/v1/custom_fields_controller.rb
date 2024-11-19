class Api::V1::CustomFieldsController < ApplicationController
  def index
    client = Client.find(params[:client_id])
    custom_fields = client.client_custom_fields

    # Format the response to include enum options as strings if they exist
    formatted_custom_fields = custom_fields.map do |field|
      field_data = {
        id: field.id,
        name: field.name,
        field_type: field.field_type
      }

      # Check if enum_values exists and convert it to a list of strings
      if field.enum_options.present?
        field_data[:enum_options] = JSON.parse(field.enum_options) # Convert to string if necessary
      end

      field_data
    end

    render json: formatted_custom_fields
  end
end
