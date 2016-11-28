class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :authorize

  def facebook
  end

  def twitter
  end

  def vkontakte
  end

  private

  def authorize
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user
      if @user.persisted?
        set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
        sign_in_and_redirect @user, event: :authentication
      else
        authorization = @user.authorizations.first
        session['devise.authorization'] = { provider: authorization.provider, uid: authorization.uid }
        redirect_to new_user_registration_path
      end
    end
  end
end
