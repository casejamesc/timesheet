class RemoveTimeOutFromShifts < ActiveRecord::Migration
  def change
    remove_column :shifts, :time_out, :datetime
  end
end
