class SessionsController < Devise::RegistrationController
  def new
    super
  end

  def create
    super do
      resource.authorizations.create(session['authentication']) if session['authentication']
    end
  end
end
