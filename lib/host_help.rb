module HostHelp

  # Add environment suffix to end of domain name to accomodate non-production
  # environment (reverse of this is HostHelp::intended_domain)
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
  
  # Remove environment suffix from domain name so it can be compared with
  # inteded value in database. For example, this would chop the "-dev" from
  # barrioearth-dev.com (reverse of this is HostHelp::domain_with_environment)
  def intended_domain(domain_from_url)
    unless ENV['RAILS_ENV'] == 'development'
      return domain_from_url
    else
      domain_parts = domain_from_url.split('.')[-2..2]
      unless domain_parts.blank? # unless no top-level domain
        return domain_parts[0].chomp('-' + ENV['RAILS_ENV'][0,3]) + '.' +
          domain_parts[1]
      end
    end
  end
end
