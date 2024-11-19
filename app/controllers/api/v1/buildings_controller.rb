class Api::V1::BuildingsController < ApplicationController
  protect_from_forgery with: :null_session

  # POST /api/v1/clients/:client_id/buildings
  def create
    client = Client.find(params[:client_id])
    address = Address.new(address_params)

    # Block ensures that all operations within it are treated as a single transaction. 
    ActiveRecord::Base.transaction do
      if address.valid?
        # Build a new building associated with the client and the address
        building = client.buildings.new(address: address)

        if building.save
          # Created BuildingCustomFieldValues
          create_custom_fields(building)

          # If everything is successful, return the created building
          render json: building, status: :created
        else
          # Raise an error to trigger a rollback if building save fails
          raise ActiveRecord::Rollback, building.errors.full_messages
        end
      else
        # Raise an error to trigger a rollback if address is invalid
        raise ActiveRecord::Rollback, address.errors.full_messages
      end
    end
  end

  # PATCH/PUT /api/v1/buildings/:id
  def update
    building = Building.find(params[:id])
    ActiveRecord::Base.transaction do
      address = building.address || building.build_address
      if address.update(address_params)
        render json: { message: 'Building updated successfully.', building: building }, status: :ok
      else
        raise ActiveRecord::Rollback, address.errors.full_messages.to_sentence
      end
    end

  rescue => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def index
    buildings = Building.includes(:client, :address)
                        .order(created_at: :desc)
                        .paginate(page: params[:page], per_page: 10)

    # Fetch all client custom fields associated with the client of the first building
    client_custom_fields = buildings.first&.client&.client_custom_fields || []
    # Calculate total pages
    total_count = Building.count
    total_pages = (total_count / 10).ceil

    render json: {
      total_pages: total_pages,
      total_count: total_count,
      buildings: buildings.map { |building|
        # Create a payload for each building and include the associated client and address
      buildingPayload = building.as_json(
          include: {
            client: { only: [:id, :name] },
            address: {}
          }
        )

        buildingPayload.merge!(
          building_custom_fields: client_custom_fields.map do |custom_field|
            {
              field_name: custom_field.name,
              value: building.building_custom_fields.find { |v| v.client_custom_field_id == custom_field.id }&.value
            }
          end
        )

        buildingPayload # Return the payload hash for this building
      }
    }, status: :ok
  end

  def show
    building = Building.find(params[:id])

    render json: building.as_json(
      include: {
        address: {}
      }
    )
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Building not found" }, status: :not_found
  end

  private

  def address_params
    params.permit(:address1, :address2, :city, :state, :country, :postal_code)
  end

  def create_custom_fields(building)
    custom_fields = params[:custom_fields]
    errors = []

    if custom_fields
      custom_fields.each do |name, value|
        client_custom_field = ClientCustomField.find_by(name: name, client: building.client)

        if client_custom_field
          # Validate the value based on the type of client_custom_field
          unless is_custom_field_valid?(client_custom_field, value)
            errors << "Invalid value for custom field '#{name}': #{value}"
            next # Skip to the next custom field if validation fails
          end

          BuildingCustomField.create!(
            building: building,
            client_custom_field: client_custom_field,
            value: value
          )
        else
          # Handle cases where the client_custom_field is not found
          Rails.logger.error("Client custom field not found for name: #{name}")
        end
      end
    end

    # rendering erros to response when anything fails
    unless errors.empty?
      render json: { errors: errors }, status: :unprocessable_entity
      raise ActiveRecord::Rollback # Trigger rollback after rendering
    end
  end

  def is_custom_field_valid?(client_custom_field, value)
    case client_custom_field.field_type
    when "number" # type number
      value.is_a?(Numeric) || (value.is_a?(String) && value.match?(/\A-?\d+(\.\d+)?\z/))
    when "enum_field"
      client_custom_field.enum_options.include?(value)
    else
      true # If the field type doesn't require validation, return true
    end
  end
end
