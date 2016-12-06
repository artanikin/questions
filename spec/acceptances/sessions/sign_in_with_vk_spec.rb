require "acceptance_helper"

feature "Sign in with Vkontakte", %(
  In order to quickly authorized
  As an vkontakte user
  I want to log in with my Vkontakte account
) do
  let(:provider) { "vkontakte" }
  it_behaves_like "Oauth with enter email"
end
