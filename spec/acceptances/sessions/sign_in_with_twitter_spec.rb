require "acceptance_helper"

feature "Sign in with twitter", %(
  In order to quickly authorized
  As an twitter user
  I want to log in with my twitter account
) do
  let(:provider) { "twitter" }
  it_behaves_like "Oauth with enter email"
end
