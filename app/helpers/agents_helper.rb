module AgentsHelper
    
  def user_snapshot(agent = nil)
    unless agent
      agent = @agent
    end
    
    '<p>
      <b>First name:</b> ' +
      agent.user.first_name +
    '</p>

    <p>
      <b>Last name:</b> ' +
      agent.user.last_name +
    '</p>

    <p>
      <b>Email:</b> ' +
      agent.user.email +
    '</p>

    <p>
      <b>Login:</b> ' +
      agent.user.login +
    '</p>'
  end
end
