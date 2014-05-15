class Notifier < ActionMailer::Base
  default from: 'no-reply@example.com'

  def credit_attachment(credit_info,data)
  	@credit = credit_info
  	@payments = data
  	mail( to: @credit.email, subject: 'Your credit info' ) do |format|
  		format.pdf do
	      attachments['#{@credit.name}.pdf'] = WickedPdf.new.pdf_from_string(
	        render_to_string(:pdf => @credit.name , :template => "credits/invoices/invoice")
	      )
	    end
	    # format.pdf{ render template: "credits/invoices/invoice", :pdf => @credit.name }
   	end
  end
end
