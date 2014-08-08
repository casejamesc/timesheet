class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.boolean :status
      t.decimal :rate
      t.boolean :default
      t.integer :user_id

      t.timestamps
    end
  end
end
