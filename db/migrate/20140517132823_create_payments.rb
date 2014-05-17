class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
    	t.date     :payment_date
	    t.float    :payment_balance
	    t.float    :princial_repayment
	    t.float    :intress_payment
	    t.float    :monthly_paymnet_total
	    t.datetime :created_at
	    t.datetime :updated_at
	    t.integer  :credit_id
    end
  end
end
