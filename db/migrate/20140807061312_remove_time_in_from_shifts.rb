class RemoveTimeInFromShifts < ActiveRecord::Migration
  def change
    remove_column :shifts, :time_in, :datetime
  end
end
