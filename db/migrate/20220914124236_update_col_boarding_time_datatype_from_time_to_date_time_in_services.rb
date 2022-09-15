class UpdateColBoardingTimeDatatypeFromTimeToDateTimeInServices < ActiveRecord::Migration[6.0]
  def up
    remove_column :services, :boarding_time
    add_column :services, :boarding_time, :datetime
  end

  def down
    remove_column :services, :boarding_time
    add_column :services, :boarding_time, :time
  end
end
