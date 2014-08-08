class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.datetime :time_in
      t.datetime :time_out
      t.integer :user_id
      t.integer :project_id
      t.integer :task_id
      t.text :notes
      t.decimal :add_cost

      t.timestamps
    end
  end
end
