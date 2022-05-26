class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.date :birthday
      t.integer :xp, default: 0

      t.timestamps
    end
  end
end
