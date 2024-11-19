class Api::V1::ClientsController < ApplicationController
  def index
    clients = Client.select(:id, :name)
    render json: clients, status: :ok
  end
end
