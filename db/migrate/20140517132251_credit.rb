class Credit < ActiveRecord::Migration
  def change
  	create_table :credits do |t|
  	t.string   :name
    t.string   :last_name
    t.integer  :phone
    t.string   :personal_id
    t.string   :email
    t.datetime :created_at
    t.datetime :updated_at
    t.float    :credit_sum
    t.integer  :credit_period
    t.date     :credit_start_date
    t.integer  :credit_intress, default: 25
  	end
  end
end
