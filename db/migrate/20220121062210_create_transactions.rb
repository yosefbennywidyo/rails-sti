class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :amount
      t.string :type
      t.belongs_to :client
      t.belongs_to :sender_wallet#, foreign_key: { to_table: :wallets }
      t.references :receiver_wallet#, foreign_key: { to_table: :wallets }

      t.timestamps
    end
  end
end
