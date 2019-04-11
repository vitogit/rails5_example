class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.text :description
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
  end
end
