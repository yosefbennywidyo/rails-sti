class Wallet < ApplicationRecord
  belongs_to :client
  has_many :outgoing_transactions, foreign_key: 'sender_wallet_id', class_name: 'Transaction'
  has_many :incoming_transactions, foreign_key: 'receiver_wallet_id', class_name: 'Transaction'
end
