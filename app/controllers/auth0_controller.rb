class Auth0Controller < ApplicationController
  skip_before_action :authorize_player

  def callback
    p 'callback'
    # This stores all the user information that came from Auth
    p request.env['omniauth.auth']
    user_info = request.env['omniauth.auth']['info']
    email = user_info['email']
    user = User.find_or_initialize_by(email:)

    user.first_name = user_info['name'].split.first if user.first_name.blank?
    user.last_name = user_info['name'].split[1..] if user.last_name.blank?
    user.password = SecureRandom.hex(10) if user.password_digest.blank?
    if user.new_record?
      group = Group.create(name: 'My first group')
      user.group = group
    end

    user.save!
    session[:user_id] = user.id
    byebug
    redirect_to root_path, notice: 'Signed in successfully'
  end

  def failure
  end

  def logout
    reset_session
    redirect_to logout_url, allow_other_host: true
  end

  private

  def logout_url
    request_params = {
      returnTo: root_url,
      client_id: AUTH0_CONFIG['auth0_client_id']
    }

    URI::HTTPS.build(host: AUTH0_CONFIG['auth0_domain'], path: '/v2/logout', query: request_params.to_query).to_s
  end
end
