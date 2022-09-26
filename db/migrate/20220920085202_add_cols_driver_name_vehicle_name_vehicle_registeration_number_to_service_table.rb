class AddColsDriverNameVehicleNameVehicleRegisterationNumberToServiceTable < ActiveRecord::Migration[6.0]
  def change
    add_column :services, :driver_name, :string, default: "-"
    add_column :services, :vehicle_name, :string, default: "-"
    add_column :services, :vehicle_registeration_number, :string, default: "-"
  end
end
