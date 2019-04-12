class PaymentAccount < ApplicationRecord
  belongs_to :user
  def add_to_balance(amount)
    self.balance = self.balance + amount
    self.save
  end
end
