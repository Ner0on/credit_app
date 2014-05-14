class CreditsController < ApplicationController
include ActionView::Helpers::NumberHelper

	def new
		@credit = Credit.new
	end
	
	def create	
		
		@credit = Credit.new(credit_params)
		@credit.save
		credit_period = credit_params[:credit_period].to_i
		credit_start_date = Date.parse(credit_params[:credit_start_date])
		credit_sum = credit_params[:credit_sum].to_f
		credit_intress = credit_params[:credit_intress].to_f

		data = calculating_graphic(credit_period,credit_start_date,credit_sum,credit_intress)
		@payment = @credit.payments.create(data)

		if @payment
			render :new
		else
			render :index
		end
	end

	def graphic_rendering

		credit_period = params[:credit_period].to_i
		credit_start_date = Date.parse(params[:credit_date])
		credit_sum = params[:credit_sum].to_f
		credit_intress = params[:credit_intress].to_f	


		data = calculating_graphic(credit_period,credit_start_date,credit_sum,credit_intress)
		render :json => data

	end
	
	def calculating_graphic(credit_period,credit_start_date,credit_sum,credit_intress)
			
			credit_intress = 0.25

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
				
				credit_start_date = credit_start_date + 1.month

				data << {
					payment_date: credit_start_date.strftime('%d.%m.%Y'),
					monthly_paymnet_total: number_to_currency(monthly_payment, precision: 2, :unit => ""),
					payment_balance: number_to_currency(balance, precision: 2, :unit => ""),
					intress_payment: number_to_currency(percent, precision: 2, :unit => ""),
					princial_repayment: number_to_currency(principal_repayment, precision: 2, :unit => "")
				}
				# Recounting with new balance
				balance -= principal_repayment
				percent = balance * credit_intress / credit_period
				principal_repayment = monthly_payment - percent

			end

			return data
	end
	
	private

	def credit_params
		params.require(:credit).permit(:name, :last_name, :email, :phone, :personal_id, :credit_sum, :credit_period, :credit_start_date, :credit_intress)
	end

	# def payment_params
	# 	params.require(:credit).except(:name, :last_name, :email, :phone, :personal_id).permit(:credit_sum, :credit_period, :credit_start_date, :credit_intress)
	# end	
end
