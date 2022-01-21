class Client < ApplicationRecord
  validates :email, presence: true
  validates :name, presence: true
  validates :email, uniqueness: true
  validates :name, uniqueness: true

  has_one :wallet
  has_many :transactions

  def user?
    type.eql?('User')
  end

  def team?
    type.eql?('Team')
  end

  def stock?
    type.eql?('Stock')
  end
end
