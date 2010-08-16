class InformationRequestObserver < ActiveRecord::Observer
  def after_create(information_request)
    # Only send if there is an email to send to
    unless information_request[:recipient_email].blank?
      InformationRequestMailer.deliver_notification(information_request)
    end
  end
end
