class Payment < ApplicationRecord
  belongs_to :sender, foreign_key: 'sender_id', class_name: 'User'
  belongs_to :receiver, foreign_key: 'receiver_id', class_name: 'User'
  validates :amount, numericality: { less_than: 1000, greater_than: 0 }
end

