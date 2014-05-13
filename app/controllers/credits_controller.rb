class CreditsController < ApplicationController
include ActionView::Helpers::NumberHelper

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
		credit_sum = params[:credit_sum].to_f
		credit_intress = params[:credit_intress].to_f	


		# monhtly payment
		rank = ( 1 + credit_intress / credit_period )**credit_period
		monthly_payment = credit_sum * (credit_intress / credit_period) / ( 1 - ( 1 / rank ))
		# percent payment
		percent = credit_sum * credit_intress / credit_period
		# balance 
		balance = credit_sum
		# main part of payment
		principal_repayment	= monthly_payment - percent
		
		data = []

		credit_period.times do
			
			payment_date = payment_date + 1.month

			data << {
				payment_date: payment_date.strftime('%d.%m.%Y'),
				monthly_payment: number_to_currency(monthly_payment, precision: 2, :unit => ""),
				balance: number_to_currency(balance, precision: 2, :unit => ""),
				intress_payment: number_to_currency(percent, precision: 2, :unit => ""),
				principal_repayment: number_to_currency(principal_repayment, precision: 2, :unit => "")
			}
			# Recounting with new balance
			balance -= principal_repayment
			percent = balance * credit_intress / credit_period
			principal_repayment = monthly_payment - percent

		end
		

		render :json => data

	end

	private

	def credit_params
		params.require(:credit).permit(:name, :last_name, :email, :phone, :personal_id, :credit_sum, :credit_period, :credit_start_date, :credit_intress)
	end

	
end
