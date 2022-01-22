class Transaction < ApplicationRecord
  validates :amount, :numericality => {:only_integer => true}
  before_create :check_sender_wallet_balance, unless: :credit?
  after_create :update_sender_and_receiver_wallet_balance, if: :debit?
  after_create :credit_wallet_balance, if: :credit?
  
  belongs_to :client
  belongs_to :user, foreign_key: 'client_id', class_name: 'Client'
  belongs_to :team, foreign_key: 'client_id', class_name: 'Client'
  belongs_to :stock, foreign_key: 'client_id', class_name: 'Client'
  belongs_to :sender_wallet, class_name: 'Wallet', optional: true
  belongs_to :receiver_wallet, class_name: 'Wallet', optional: true

  scope :credit, -> (user_wallet) { where(receiver_wallet_id: user_wallet.id).where(type: 'Credit') }
  scope :debit, -> (user_wallet) { where(sender_wallet_id: user_wallet.id).where("amount < ?", 0) }
  scope :total_credit, -> (user_wallet) { where(receiver_wallet_id: user_wallet.id).where(type: 'Credit').sum(:amount) }
  scope :total_debit, -> (user_wallet) { where(sender_wallet_id: user_wallet.id).where("amount < ?", 0).sum(:amount) }
  scope :balance, -> (user_wallet) { total_credit(user_wallet) + total_debit(user_wallet) }

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

  def update_sender_and_receiver_wallet_balance
    @sender_wallet.update(balance: @sender_wallet.balance + self.amount)

    if @receiver_wallet.present?
      @receiver_wallet.update(balance: @receiver_wallet.balance.to_i - self.amount)
      Credit.create(client_id: self.client_id, amount: self.amount * -1, receiver_wallet: @receiver_wallet, sender_wallet: @sender_wallet)
    end
  end

  def credit_wallet_balance
    setup_sender_receiver_wallet
    @receiver_wallet.update(balance: @receiver_wallet.balance.to_i + self.amount)
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
