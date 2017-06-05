require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:admin) { create(:user, :is_admin) }

  describe '#create' do
    describe 'signed_in' do
      let(:firstname)   { 'foo' }
      let(:lastname)    { 'baa' }
      let(:email)       { 'foo@baa.de' }
      let(:street)      { 'Ericaweg' }
      let(:zip)         { '22303' }
      let(:city)        { 'Hamburg' }
      let(:gender)      { 'male' }
      let(:membership)  { 'full' }
      let(:password)    { 'changeme' }
      let(:member_number)  { 123456 }
      let(:password_confirmation) { 'changeme' }

      subject do
        post :create,
          params: {
             user: {
               first_name: firstname,
                last_name: lastname,
                email: email,
                membership: membership,
                gender: gender,
                street: street,
                city: city,
                zip: zip,
                member_number: member_number,
                password: password,
                password_confirmation: password_confirmation
            }
          }
      end

      before { sign_in(admin) }

      let(:user) { User.last }
      it 'creates a new user' do
        subject
        expect(user.first_name).to eq firstname
        expect(user.last_name).to eq lastname
        expect(user.email).to eq email
        expect(user.gender).to eq gender
        expect(user.street).to eq street
        expect(user.zip).to eq zip
        expect(user.city).to eq city
        expect(user.membership).to eq membership
        expect(user.member_number).to eq member_number
      end
    end

    describe 'logged out' do
      it 'redirects to login page' do
        put :update, params: { id: 111 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#update' do
    describe 'signed_in' do

    end

    describe 'logged out' do
      it 'redirects to login page' do
        put :update, params: { id: 111 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
