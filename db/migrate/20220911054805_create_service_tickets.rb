class CreateServiceTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :service_tickets do |t|
      t.references :service, foreign_key: true
      t.references :passenger, index: true, foreign_key: { to_table: :users }, class_name: 'User'
      t.boolean :request_status, default: false
      t.timestamps
    end
  end
end
