class CreditsController < ApplicationController

	def new
	end
	
	def create
		@result = Credit.new(credit_params)
		# 2.times { @person.addresses.build}
		if @result.save
			render :new
		else
			render :index
		end
	end

	private

	def credit_params
		params.require(:credit).permit(:name, :last_name, :email, :phone, :personal_id, :credit_sum, :credit_period, :credit_start_date, :credit_intress)
	end
end
