class AddClockInAndClockOutAndDateInAndDateOutToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :clock_in, :time
    add_column :shifts, :clock_out, :time
    add_column :shifts, :date_in, :date
    add_column :shifts, :date_out, :date
  end
end
