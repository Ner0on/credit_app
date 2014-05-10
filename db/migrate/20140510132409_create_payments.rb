class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
    
    t.date :payment_date
    t.float :payment_balance
    t.float :princial_repayment
    t.float :intress_payment
    t.float :monthly_paymnet_total

      t.timestamps
    end
  end
end
