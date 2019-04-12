class User < ApplicationRecord
  has_many :sent_payments, class_name: "Payment", foreign_key: "sender_id"
  has_many :received_payments, class_name: "Payment", foreign_key: "receiver_id"
  has_many :friendships
  has_many :friends, :through => :friendships
  has_one :payment_account
  validates_presence_of :name

  def feed(page = 1, per_page = 10)
    feed = []
    feed_ids = self.friends.pluck(:id) + [self.id]
    payments = Payment.where(sender_id: feed_ids).order(created_at: :desc)
    payments.page(page).per(per_page).each do |payment|
      sender = payment.sender.name
      receiver = payment.receiver.name
      description = payment.description
      timestamp = payment.created_at
      feed.push({title: "#{sender} paid #{receiver} on #{timestamp}. #{description}"})
    end
    feed
  end
end
