require "rails_helper"

RSpec.describe SearchesController, type: :controller do
  describe "GET #index" do
    before { get :index, params: { q: "" } }

    it "render index view" do
      expect(response).to render_template :index
    end
  end
end
