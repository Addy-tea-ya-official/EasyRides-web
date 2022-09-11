class RemoveColumnDriverIdFromService < ActiveRecord::Migration[6.0]
  def change
    remove_column :services, :driver_id
  end
end
