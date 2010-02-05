module HostHelp

  def current_domain
    # When tacking on "dev" in development environment, request.domain returns
    # "real_tld.dev" instead of "domain.real_tld", i.e. "com.dev" instead of
    # "barrioearth.com.dev". To fix this, we retrieve the last subdomain and
    # append request.domain
    unless ENV['RAILS_ENV'] == 'development' && SubdomainFu.tld_size > 1
      return request.domain
    end
    return request.subdomains.last + '.' + request.domain
  end
  
  # Add environment suffix to tld to accomodate non-production environment
  # (reverse of this is HostHelp::intended_domain)
  def domain_with_environment(domain)
    # tld size of 2 means we're tacking on ".dev" in development environment
    # which must be removed
    unless ENV['RAILS_ENV'] == 'development' && SubdomainFu.tld_size > 1
      return domain_from_url
    end
    domain_parts = domain.split('.')
    return if domain_parts.blank?
    return domain_parts.push(ENV['RAILS_ENV'][0,3]).join('.')
  end
  
  # Remove environment suffix from tld so it can be compared with inteded
  # value in database. For example, this would chop the ".dev" from
  # barrioearth.com.dev (reverse of this is HostHelp::domain_with_environment)
  def intended_domain(domain_from_url)
    # tld size of 2 means we're tacking on ".dev" in development environment
    # which must be removed
    unless ENV['RAILS_ENV'] == 'development' && SubdomainFu.tld_size > 1
      return domain_from_url
    end
      
    domain_parts = domain_from_url.split('.')
    return if domain_parts.blank? # unless no top-level domain
    domain_parts.pop
    return domain_parts.join('.')
  end
  
#  # Add environment suffix to end of domain name to accomodate non-production
#  # environment (reverse of this is HostHelp::intended_domain)
#  def domain_with_environment(domain)
#    unless ENV['RAILS_ENV'] == 'development'
#      return domain
#    else
#      domain_parts = domain.split('.')[-2..2]
#      unless domain_parts.blank? # unless no top-level domain
#        return domain_parts[0] + '-' + ENV['RAILS_ENV'][0,3] + 
#          '.' + domain_parts[1]
#      end
#    end
#  end
  
#  # Remove environment suffix from domain name so it can be compared with
#  # inteded value in database. For example, this would chop the "-dev" from
# # barrioearth-dev.com (reverse of this is HostHelp::domain_with_environment)
#  def intended_domain(domain_from_url)
#    return domain_from_url unless ENV['RAILS_ENV'] == 'development'
#      
#    domain_parts = domain_from_url.split('.')[-2..2]
#    unless domain_parts.blank? # unless no top-level domain
#      return domain_parts[0].chomp('-' + ENV['RAILS_ENV'][0,3]) + '.' +
#        domain_parts[1]
#    end
#  end
end
