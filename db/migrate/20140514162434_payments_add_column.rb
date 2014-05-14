class PaymentsAddColumn < ActiveRecord::Migration
  def change
  	add_column :payments, :credit_id, :integer
  end
end
