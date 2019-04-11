#Add users
ruy = User.create(name: 'Ruy Lopez')
capablanca = User.create(name: 'Jose Capablanca')
karpov = User.create(name: 'Anatoly Karpov')

# Add payments accounts for each user
ruy.create_payment_account({balance: 500, external_balance: 100})
capablanca.create_payment_account({balance: 500, external_balance: 100})
karpov.create_payment_account({balance: 500, external_balance: 100})

#Add friends
ruy.friends << capablanca
karpov.friends << capablanca

# Add payments
Payment.create(amount: 200, sender_id: ruy.id, receiver_id: capablanca.id, description: 'Won game')
Payment.create(amount: 200, sender_id: karpov.id, receiver_id: capablanca.id, description: 'Checkmate')