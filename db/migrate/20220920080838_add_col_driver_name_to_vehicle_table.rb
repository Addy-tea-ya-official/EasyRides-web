class AddColDriverNameToVehicleTable < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicles, :driver_name, :string, default: "-"
  end
end
