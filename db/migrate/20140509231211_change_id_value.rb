class ChangeIdValue < ActiveRecord::Migration
	def change
		change_column :credits, :personal_id, :bigint
	end
end
