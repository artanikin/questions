module AcceptenceHelper
  def sign_in(user)
    page.set_rack_session(
      'warden.user.user.key' => User.serialize_into_session(user)
    )
  end
end
