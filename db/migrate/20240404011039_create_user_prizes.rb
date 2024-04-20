class CreateUserPrizes < ActiveRecord::Migration[6.1]
  def change
    create_table :user_prizes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :prize, null: false, foreign_key: true
      t.datetime :purchased_at
      t.datetime :redeemed_at


      t.timestamps
    end
  end
end
