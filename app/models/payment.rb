class Payment < ApplicationRecord
  belongs_to :sender, foreign_key: 'sender_id', class_name: 'User'
  belongs_to :receiver, foreign_key: 'receiver_id', class_name: 'User'
  validates :amount, numericality: { less_than: 1000, greater_than: 0 }
  validate :friendship

  def friendship
    friend = Friendship.where(user_id: sender.try(:id), friend_id: receiver.try(:id))
    if friend.empty?
      errors.add(:payment, "Receiver is not a friend of Sender")
    end
  end
end

