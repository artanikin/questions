module OmniauthMacros
  def mock_auth_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123456',
      info: { email: 'facexample@mail.com' }
    })
  end

  def mock_auth_without_email(provider)
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: provider,
      uid: '123456',
      info: {}
    })
  end

  def mock_auth_invalid(provider)
    OmniAuth.config.mock_auth[provider] = :credentials_are_invalid
  end
end
