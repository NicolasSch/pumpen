# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:admin) { create(:user, :is_admin) }

  let(:firstname)   { 'foo' }
  let(:lastname)    { 'baa' }
  let(:email)       { 'foo@baa.de' }
  let(:street)      { 'Ericaweg' }
  let(:zip)         { '22303' }
  let(:city)        { 'Hamburg' }
  let(:gender)      { 'male' }
  let(:membership)  { 'full' }
  let(:password)    { 'changeme' }
  let(:member_number) { 123_456 }
  let(:password_confirmation) { 'changeme' }

  describe '#create' do
    describe 'signed_in' do
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
      end

      it 'creates a new user with address' do
        subject
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
      subject do
        post :update,
             params: {
               id: user.id,
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
                 password_confirmation: password_confirmation,
                 archived: true
               }
             }
      end

      before do
        sign_in(admin)
      end

      let!(:user) { create(:user) }

      it 'updates an existing user' do
        subject
        expect(user.reload.first_name).to eq firstname
        expect(user.reload.last_name).to eq lastname
        expect(user.reload.email).to eq email
        expect(user.reload.gender).to eq gender
        expect(user.reload.membership).to eq membership
        expect(user.reload.member_number).to eq member_number
        expect(user.reload.archived).to be true
      end

      it 'updates an existing user address' do
        subject
        expect(user.reload.street).to eq street
        expect(user.reload.zip).to eq zip
        expect(user.reload.city).to eq city
      end
    end

    describe 'logged out' do
      it 'redirects to login page' do
        put :update, params: { id: 111 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#destroy' do
    describe 'signed_in' do
      subject do
        post :destroy, params: { id: user.id }
      end

      before do
        sign_in(admin)
      end

      let!(:user) { create(:user) }

      it 'destroys an user' do
        expect { subject }.to change(User, :count).from(2).to(1)
      end
    end
  end
end
