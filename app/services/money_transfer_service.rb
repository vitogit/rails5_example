class MoneyTransferService
 attr_reader :external_payment_source,  :user_payment_account
 def initialize (external_payment_source, user_payment_account) 
   @external_payment_source = external_payment_source 
   @user_payment_account = user_payment_account
 end

 def transfer(amount) 
   external_payment_source.try(:send_money, amount) 
   user_payment_account.try(:add_to_balance, amount)  
   true
 end 
end