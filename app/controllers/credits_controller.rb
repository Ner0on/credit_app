class CreditsController < ApplicationController
include ActionView::Helpers::NumberHelper
	
	# def show
	# 	@credit = Credit.find(params[:id])
	# 	@payments = Payment.where(credit_id:params[:id])
	# 	respond_to do |format|
	#     	format.pdf{ render template: "credits/invoices/invoice", :pdf => 'crdit_invoice' }
	#     end
	# end

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
			Notifier.credit_attachment(@credit,data).deliver
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

	def calculating_payments()
		
		credit_period = params[:credit_period].to_i
		credit_start_date = Date.parse(params[:credit_date])
		credit_sum = params[:credit_sum].to_f
		credit_intress = params[:credit_intress].to_f	

		data = calculating_graphic(credit_period,credit_start_date,credit_sum,credit_intress)

		monthly_paymnet_total = data[0][:monthly_paymnet_total].to_f
		raw_inress_sum = (monthly_paymnet_total * credit_period) - credit_sum
		inress_sum  = number_to_currency(raw_inress_sum, precision: 2,:unit => "", :delimiter => "" )
		render :json => {monthly_paymnet_total: monthly_paymnet_total, inress_sum: inress_sum}
	end
	
	def calculating_graphic(credit_period,credit_start_date,credit_sum,credit_intress)
			
			credit_intress = 0.25


			# monhtly payment
			year_percent = credit_intress / 12 
			rank = ( 1 + year_percent )**credit_period - 1
			monthly_payment = credit_sum * ( year_percent + (year_percent / rank))

			intress_payment = monthly_payment * credit_period - credit_sum
			# percent payment
			percent = credit_sum * year_percent
			# balance 
			balance = credit_sum
			# main part of payment
			principal_repayment	= monthly_payment - percent
			
			data = []
			
			credit_period.times do
				
				credit_start_date = credit_start_date + 1.month

				data << {
					payment_date: credit_start_date.strftime('%d.%m.%Y'),
					monthly_paymnet_total: number_to_currency(monthly_payment, precision: 2, :unit => "", :delimiter => ""),
					payment_balance: number_to_currency(balance, precision: 2, :unit => "", :delimiter => ""),
					intress_payment: number_to_currency(percent, precision: 2, :unit => "", :delimiter => ""),
					princial_repayment: number_to_currency(principal_repayment, precision: 2, :unit => "", :delimiter => "")
				}
				# Recounting with new balance
				balance -= principal_repayment
				percent = balance * year_percent
				principal_repayment = monthly_payment - percent

			end

			return data
			
	end
	
	private

	def credit_params
		params.require(:credit).permit(:name, :last_name, :email, :phone, :personal_id, :credit_sum, :credit_period, :credit_start_date, :credit_intress)
	end	
end
