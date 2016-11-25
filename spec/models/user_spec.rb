require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:user) { create(:user) }

    it 'user is the author of the question' do
      question = create(:question, author: user)
      expect(user).to be_author(question)
    end

    it 'user is not the not author of the question' do
      question = create(:question)
      expect(user).to_not be_author(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user alredy has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'return the user' do
          expect(User.find_for_oauth(auth)).to eq(user)
        end
      end

      context 'user does not exist' do
        context 'provider has email' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

          it 'creates new user' do
            expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
          end

          it 'returns new user' do
            expect(User.find_for_oauth(auth)).to be_a(User)
          end

          it 'fills user email' do
            user = User.find_for_oauth(auth)
            expect(user.email).to eq auth.info[:email]
          end

          it 'creates authorization for user' do
            user = User.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end

          it 'creates authorizations with provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first
            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end

        context 'provider has not email' do
          let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: {}) }

          it 'initialize user' do
            expect(User.find_for_oauth(auth)).to_not be_persisted
          end

          it 'initialize authorization' do
            authorization = User.find_for_oauth(auth).authorizations.first
            expect(authorization).to_not be_persisted
            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end
      end
    end
  end
end
