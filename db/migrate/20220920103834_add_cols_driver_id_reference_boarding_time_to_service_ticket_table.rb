class AddColsDriverIdReferenceBoardingTimeToServiceTicketTable < ActiveRecord::Migration[6.0]
  def change
    add_column :service_tickets, :boarding_time, :datetime
    add_reference :service_tickets, :driver, index: true, foreign_key: { to_table: :users }, class_name: 'User'
  end
end
