class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :points, default: 0, null: false
      t.integer :assigned_user_id, null: false
      t.integer :created_by_id, null: false
      t.string :status, default: 'pending', null: false
      t.boolean :repeating, default: false
      t.string :repeat_frequency
      t.datetime :due_date
      t.datetime :completed_at

      t.timestamps
    end

    add_index :tasks, :assigned_user_id
    add_index :tasks, :created_by_id
    add_index :tasks, :status
    add_index :tasks, [:assigned_user_id, :status]
  end
end
