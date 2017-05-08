account = Account.create!(username: 'admin')
user = User.create!(email: 'admin@localhost', password: 'password', admin: true, account: account)
user.confirm
account.save!
user.save!
