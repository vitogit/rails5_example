require 'rails_helper'

RSpec.describe User, type: :model do
  # Association test
  # ensure User model has a 1:m relationship with the Payments
  it { should have_many(:received_payments) }
  it { should have_many(:sent_payments) }
  # ensure User model has a 1:1 relationship with the Payment Account
  it { should have_one(:payment_account) }
  # ensure User model has a 1:m relationship with the friendship relationship
  it { should have_many(:friends) }
  it { should have_many(:friendships) }
  # Validation tests
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }
end
