class InformationRequestMailer < ActionMailer::Base
  
  helper :information_requests
  
  def recipient_parts(information_request)
    {
      :email => information_request[:recipient_email],
      :name => information_request[:recipient_name]
    }
  end
  
  def sender_parts(information_request)
    unless information_request[:email].blank?
      sender[:email] = information_request[:email]
      sender[:name] = 'User Services on behalf of ' + sender[:email]
      return sender
    end
    if information_request[:recipient_email].blank?
      return nil
    else
      sender[:email] = information_request[:recipient_email]
      unless information_request[:name].blank?
        sender[:name] = 'User Services on behalf of ' +
          information_request[:name]
      else
        sender[:name] = 'User Services on behalf of anonymous visitor'
      end
      return sender
    end
  end
  
  def parts_to_header(parts)
    header = ''
    if parts[:name]
      header += parts[:name] + ' '
    end
    header += '<' + parts[:email] + '>'
  end
  
  def subject_of_email(information_request)
    unless information_request[:subject].blank?
      information_request[:subject]
    else
      'Property Information Request'
    end
  end
  
  def notification(information_request)    
    # Recipients
    recipients parts_to_header(recipient_parts(information_request))
      
    # From
    from parts_to_header(sender_parts(information_request))
    
    # Reply to address should be the individual's address who sent the request
    reply_to parts_to_header(information_request)
    
    # BCC default email address unless it is already the recipient
    #bcc
    
    # Subject
    subject subject_of_email(information_request)
    
    # Date
    sent_on Time.now
    
    # Message body
    body :information_request => information_request
  end
end

# Possible headers:
#
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
