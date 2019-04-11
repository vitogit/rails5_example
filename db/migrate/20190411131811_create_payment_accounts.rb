class CreatePaymentAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_accounts do |t|
      t.decimal :balance, precision: 8, scale: 2
      t.decimal :external_balance, precision: 8, scale: 2
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
