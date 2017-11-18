class AuthController < ApplicationController

  def sign_in
    sso = SsoWithDiscourse::Sso.new
    session[:sso] = sso

    redirect_to sso.request_url
  end

  # @todo Move that to service
  def comeback
    sso = ::SsoWithDiscourse::Sso.new
    sso.nonce = session[:sso]['nonce']
    sso.parse(params)

    if sso.status == 'success'
      user = User.find_by(discourse_id: sso.user_info[:external_id])

      attrs = {
        discourse_id: sso.user_info[:external_id],
        name:         sso.user_info[:name],
        username:     sso.user_info[:username],
        email:        sso.user_info[:email],
        is_admin:     sso.user_info[:admin].to_s == 'true',
        is_moderator: sso.user_info[:moderator].to_s == 'true'
      }

      if user.present?
        logger.info 'User present. Updating.'
        user.update_attributes(attrs)
      else
        logger.info 'User not present. Creating.'
        user = User.create! attrs.merge!(
          active: true,
          approved: true,
          confirmed: true
        )
      end

      # Create session
      UserSession.new(user).save!

      # Sync profile
      SyncUserProfileJob.perform_later(user.id)

      redirect_to root_path, notice: 'Zalogowano pomyślnie!'
    else
      redirect_to root_path, notice: 'Coś poszło nie tak przy próbie zalogowania. Spróbuj ponownie za chwilę.'
    end
  end

  def sign_out
    current_user_session.destroy
    redirect_to root_path, notice: 'Wylogowano pomyślnie!'
  end

end
