class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.integer :balance
      t.belongs_to :client, index: true, foreign_key: true

      t.timestamps
    end
  end
end
