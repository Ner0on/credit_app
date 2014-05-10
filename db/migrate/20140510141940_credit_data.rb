class CreditData < ActiveRecord::Migration
  def change
  	add_column :credits, :credit_sum, :float
  	add_column :credits, :credit_period, :integer
  	add_column :credits, :credit_start_date, :date
  	add_column :credits, :credit_intress, :integer, default: 25
  end
end
