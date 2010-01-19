module HostHelp

  def domain_with_environment(domain)
    unless ENV['RAILS_ENV'] == 'development'
      return domain
    else
      domain_parts = domain.split('.')[-2..2]
      unless domain_parts.blank? # unless no top-level domain
        return domain_parts[0] + '-' + ENV['RAILS_ENV'][0,3] + 
          '.' + domain_parts[1]
      end
    end
  end
end
