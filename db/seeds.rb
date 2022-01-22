# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
for i in 1..2 do
  User.create(name: "User-#{i}", email: "user-#{i}@test.com")
  Team.create(name: "Team-#{i}", email: "team-#{i}@test.com")
  Stock.create(name: "Stock-#{i}", email: "stock-#{i}@test.com")
end

puts "created #{Client.count} clients"

User.all.each do |user|
  Wallet.create(client_id: user.id)
end

puts "created #{User.includes(:wallet).count} user wallets"

Team.all.each do |team|
  Wallet.create(client_id: team.id)
end

puts "created #{Team.includes(:wallet).count} team wallets"

Stock.all.each do |stock|
  Wallet.create(client_id: stock.id)
end

puts "created #{Stock.includes(:wallet).count} stock wallets"

first_user = User.first
second_user = User.second

Credit.create(amount: 1000, client: first_user, receiver_wallet: first_user.wallet)
Credit.create(amount: 1000, client: second_user, receiver_wallet: second_user.wallet)

Debit.create(amount: 100, client: first_user, sender_wallet: first_user.wallet)
Debit.create(amount: 100, client: first_user, sender_wallet: first_user.wallet, receiver_wallet: second_user.wallet)
Debit.create(amount: 1000, client: second_user, sender_wallet: second_user.wallet)