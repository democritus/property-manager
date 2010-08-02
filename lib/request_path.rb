module RequestPath
  
  def request_path_parts
    request.path.split('/').compact.reject { |s| s.strip.empty? }
  end
end
