class Payment < ApplicationRecord
  belongs_to :sender, class_name: "User", primary_key: "sender_id"
  belongs_to :receiver, class_name: "User", primary_key: "receiver_id"
  validates :amount, numericality: { less_than: 1000, greater_than: 0 }
end
