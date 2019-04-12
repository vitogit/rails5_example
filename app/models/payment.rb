class Payment < ApplicationRecord
  belongs_to :sender, foreign_key: 'sender_id', class_name: 'User'
  belongs_to :receiver, foreign_key: 'receiver_id', class_name: 'User'
  validate :friendship
  before_save :transfer_money
  validates :amount, numericality: { less_than: 1000, greater_than: 0 }
  after_save :modify_balance

  def friendship
    friend = Friendship.where(user_id: sender.try(:id), friend_id: receiver.try(:id))
    if friend.empty?
      errors.add(:payment, "Receiver is not a friend of Sender")
    end
  end

  def transfer_money
    left_money = sender.payment_account.balance - self.amount
    # Not enough money transfer from external account to the user payment account
    if left_money < 0
      mts = MoneyTransferService.new({ name: 'external_service' }, sender.payment_account)
      needed_money = left_money * -1
      mts.transfer(needed_money)
    end
  end
  
  def modify_balance
    sender.payment_account.add_to_balance(-self.amount)
    receiver.payment_account.add_to_balance(self.amount)
  end
end

