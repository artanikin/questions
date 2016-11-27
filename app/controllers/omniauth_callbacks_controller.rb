class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :authorize

  def facebook
  end

  def twitter
  end

  private

  def authorize
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      session.delete(:authorization)
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      authorization = @user.authorizations.first
      session['authorization'] = { provider: authorization.provider, uid: authorization.uid }
      redirect_to new_user_registration_path
    end
  end
end