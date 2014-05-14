class Credit < ActiveRecord::Base
	has_many :payments, dependent: :destroy
	accepts_nested_attributes_for :payments
end
