class AddColsPassengerNamePassengerEmailToServiceTicketTable < ActiveRecord::Migration[6.0]
  def change
    add_column :service_tickets, :passenger_name, :string, default: "-"
    add_column :service_tickets, :passenger_email, :string, default: "-"
  end
end
