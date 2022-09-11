class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|
      t.string :name, default: "-"
      t.string :registeration_number, :null => false
      t.integer :capacity, default: 0
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
