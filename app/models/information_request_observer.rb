class InformationRequestObserver < ActiveRecord::Observer
  def after_create(information_request)
    # Only send if there is an email to send to
    unless information_request[:intended_recipient_email].blank?
      InformationRequestMailer.deliver_notification(information_request)      
      # Update record's recipient fields upon successful delivery
      information_request.recipient_email = information_request[:intended_recipient_email]
      information_request.recipient_name = information_request[:intended_recipient_name]
      information_request.save!
    end
  end
end
