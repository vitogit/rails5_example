require 'rails_helper'

RSpec.describe PaymentAccount, type: :model do
  it { should belong_to(:user) }
end
