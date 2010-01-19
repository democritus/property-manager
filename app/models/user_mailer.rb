class UserMailer < ActionMailer::Base

  def information_request_email(user)
    recipients user.email
    from "User Services <user_services@barrioearth.com>"
    reply_to "BarrioEarth Real Estate <realestate@barrioearth.com>"
    bcc "BarrioEarth Real Estate <realestate@barrioearth.com>"
    subject "Welcome to BarrioEarth!"
    sent_on Time.now
    #body :user => user
    #body :user => user, :url => "http://www.barrioearth.com/login"
  end

end

# bcc	 The BCC addresses of the email
# body	 The body of the email. This is either a hash (in which case it specifies the variables to pass to the template when it is rendered), or a string, in which case it specifies the actual body of the message
# cc	 The CC addresses for the email
# charset	 The charset to use for the email. This defaults to the default_charset specified for ActionMailer::Base.
# content_type	 The content type for the email. This defaults to “text/plain” but the filename may specify it
# from	 The from address of the email
# reply_to	 The address (if different than the “from” address) to direct replies to this email
# headers	 Additional headers to be added to the email
# implicit_parts_order	 The order in which parts should be sorted, based on the content type. This defaults to the value of default_implicit_parts_order
# mime_version	 Defaults to “1.0”, but may be explicitly given if needed
# recipient	 The recipient addresses of the email, either as a string (for a single address) or an array of strings (for multiple addresses)
# sent_on	 The timestamp on which the message was sent. If unset, the header will be set by the delivery agent
# subject	 The subject of the email
# template	 The template to use. This is the “base” template name, without the extension or directory, and may be used to have multiple mailer methods share the same template