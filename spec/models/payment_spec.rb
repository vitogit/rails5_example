require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { should belong_to(:receiver) }
  it { should belong_to(:sender) }

  it { should validate_numericality_of(:amount).is_greater_than(0) }
  it { should validate_numericality_of(:amount).is_less_than(1000) }
end
