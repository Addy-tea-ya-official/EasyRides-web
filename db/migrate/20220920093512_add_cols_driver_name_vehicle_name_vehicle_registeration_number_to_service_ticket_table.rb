class AddColsDriverNameVehicleNameVehicleRegisterationNumberToServiceTicketTable < ActiveRecord::Migration[6.0]
  def change
    add_column :service_tickets, :driver_name, :string, default: "-"
    add_column :service_tickets, :vehicle_name, :string, default: "-"
    add_column :service_tickets, :vehicle_registeration_number, :string, default: "-"
  end
end
