class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.boolean :status
      t.decimal :rate
      t.boolean :default
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
