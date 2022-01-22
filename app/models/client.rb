class Client < ApplicationRecord
  validates :email, presence: true
  validates :name, presence: true
  validates :email, uniqueness: true
  validates :name, uniqueness: true

  has_one :wallet, dependent: :destroy
  has_many :transactions

  scope :exclude, -> (*values) { 
    where(
      "#{table_name}.id NOT IN (?)",
        (
          values.compact.flatten.map { |e|
            if e.is_a?(Integer) 
              e
            else
              e.is_a?(self) ? e.id : raise("Element not the same type as #{self}.")
            end
          } << 0
        )
      )
    }

  def self.users
    where(type: 'User')
  end

  def self.teams
    where(type: 'Team')
  end

  def self.stocks
    where(type: 'Stock')
  end
  
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
