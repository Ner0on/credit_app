class CreditsController < ApplicationController

	def new
		@credit = Credit.new
	end
	
	def create	
		@credit = Credit.new(credit_params)
		# 2.times { @person.addresses.build}
		if @credit.save
			render :new
		else
			render :index
		end
	end

	def graphic_rendering

		credit_period = params[:credit_period].to_i
		payment_date = Date.parse(params[:credit_date])

		data = []
		credit_period.times do |c|
			credit_sum = params[:credit_sum]
			credit_intress = params[:credit_intress]	
		    payment_date = payment_date + 1.month
			
			data << {
				payment_date: payment_date,
				monthly_payment: payment_date
			}
		end
		

		render :json => data

	end

	private

	def credit_params
		params.require(:credit).permit(:name, :last_name, :email, :phone, :personal_id, :credit_sum, :credit_period, :credit_start_date, :credit_intress)
	end

	
end
