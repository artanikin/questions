require 'rails_helper'

describe 'Profiles API' do
  describe 'GET /me' do
    let(:http_method) { :get }
    let(:url) { me_api_v1_profiles_path }

    it_behaves_like "API unauthorized"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request(:get, url, { access_token: access_token.token }) }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(email id created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /index' do
    let(:http_method) { :get }
    let(:url) { api_v1_profiles_path }

    it_behaves_like "API unauthorized"

    context 'authorized' do
      let!(:john) { create(:user) }
      let!(:bob) { create(:user) }
      let!(:tom) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: john.id) }

      before { do_request(:get, url, { access_token: access_token.token }) }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns 2 users' do
        expect(response.body).to have_json_size(2)
      end

      it 'does not contains current_user' do
        expect(response.body).to_not include_json(john.to_json)
      end

      %w(bob tom).each do |user|
        it "contains user #{user}" do
          expect(response.body).to include_json(send(user.to_sym).to_json)
        end

        context "#{user} contains attribute" do
          let!(:current_user) { send(user.to_sym) }
          let!(:body) { JSON.parse(response.body).detect{ |item| item['email'] == current_user.email }.to_json }

          %w(email id created_at updated_at admin).each do |attr|
            it attr do
              expect(body).to be_json_eql(current_user.send(attr.to_sym).to_json).at_path(attr)
            end
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          JSON.parse(response.body).each do |body|
            expect(body.to_json).to_not have_json_path(attr)
          end
        end
      end
    end
  end
end
