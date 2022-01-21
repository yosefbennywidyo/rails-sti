class Transaction < ApplicationRecord
  before_create :check_sender_wallet_balance, unless: :credit?
  after_create :update_sender_and_receiver_wallet_balance, if: :debit?
  after_create :credit_wallet_balance, if: :credit?
  
  belongs_to :client
  belongs_to :user, foreign_key: 'client_id', class_name: 'Client'
  belongs_to :team, foreign_key: 'client_id', class_name: 'Client'
  belongs_to :stock, foreign_key: 'client_id', class_name: 'Client'
  belongs_to :sender_wallet, class_name: 'Wallet', optional: true
  belongs_to :receiver_wallet, class_name: 'Wallet', optional: true

  scope :incoming_transactions, -> (user_wallet) { where(receiver_wallet_id: user_wallet.id).where(type: 'Credit').sum(:amount) }
  scope :outgoing_transactions, -> (user_wallet) { where(sender_wallet_id: user_wallet.id).where("amount < ?", 0).sum(:amount) }
  scope :balance, -> (user_wallet) { incoming_transactions(user_wallet) + outgoing_transactions(user_wallet) }

  def setup_sender_receiver_wallet
    @sender_wallet = self.sender_wallet
    @receiver_wallet = self.receiver_wallet
  end

  def check_sender_wallet_balance
    setup_sender_receiver_wallet
    if @sender_wallet.balance < self.amount
      raise "Insufficient funds"
    end
  end

  def cache_setup(user_wallet)
    @cache = Rails.cache
    
    @cache.fetch("incoming_transactions_for_user_with_id_#{user_wallet.client_id}") do
      Transaction.incoming_transactions(user_wallet)
    end
    
    @cache.fetch("outgoing_transactions_for_user_with_id_#{user_wallet.client_id}") do
      Transaction.outgoing_transactions(user_wallet)
    end
    
    @cache.fetch("balance_for_user_with_id_#{user_wallet.client_id}") do
      Transaction.balance(user_wallet)
    end
  end

  def update_sender_and_receiver_wallet_balance
    @sender_wallet.update(balance: @sender_wallet.balance + self.amount)
    cache_setup(@sender_wallet)

    if @receiver_wallet.present?
      @receiver_wallet.update(balance: @receiver_wallet.balance.to_i - self.amount)
      Credit.create(client_id: self.client_id, amount: self.amount * -1, receiver_wallet: @receiver_wallet, sender_wallet: @sender_wallet)
      cache_setup(@receiver_wallet)
    end
  end

  def credit_wallet_balance
    setup_sender_receiver_wallet
    @receiver_wallet.update(balance: @receiver_wallet.balance.to_i + self.amount)
    cache_setup(@receiver_wallet)
  end

  def credit?
    self.type == 'Credit'
  end

  def debit?
    self.type == 'Debit'
  end

  def transfer?
    self.type == 'Transfer'
  end
end
