class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.string :balance
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
