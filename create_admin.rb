account = Account.create!(username: 'mastodon')
user = User.create!(email: 'mastodon@localhost', password: 'password', admin: true, account: account)
user.confirm
account.save!
user.save!
