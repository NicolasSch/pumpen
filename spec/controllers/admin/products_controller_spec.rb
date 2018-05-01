# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  let!(:admin) { create(:user, :is_admin) }

  let(:title)               { 'foo' }
  let(:price)               { 20.00 }
  let(:plu)                 { '123' }
  let(:product_group)       { 'Questbar' }
  let(:product_group_id)    { 1234 }
  let(:product_type) { 'Standard' }

  describe '#create' do
    describe 'signed_in' do
      subject do
        post :create,
             params: {
               product: {
                 title: title,
                 price: price,
                 plu: plu,
                 product_group: product_group,
                 product_type: product_type,
                 product_group_id: product_group_id
               }
             }
      end

      before { sign_in(admin) }

      let(:product) { Product.last }

      it 'creates a new Prodcut' do
        subject
        expect(product.title).to eq title
        expect(product.price).to eq price
        expect(product.plu).to eq plu
        expect(product.archived).to be false
        expect(product.product_group).to eq product_group
        expect(product.product_group_id).to eq product_group_id
        expect(product.product_type).to eq product_type
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
               id: product.id,
               product: {
                 title: title,
                 price: price,
                 plu: plu,
                 archived: true,
                 product_group: product_group,
                 product_type: product_type,
                 product_group_id: product_group_id
               }
             }
      end

      before do
        sign_in(admin)
      end

      let!(:product) { create(:product) }

      it 'updates an existing product' do
        subject
        expect(product.reload.title).to eq title
        expect(product.reload.price).to eq price
        expect(product.reload.plu).to eq plu
        expect(product.reload.archived).to be true
        expect(product.reload.product_group).to eq product_group
        expect(product.reload.product_group_id).to eq product_group_id
        expect(product.reload.product_type).to eq product_type
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
        post :destroy, params: { id: product.id }
      end

      before do
        sign_in(admin)
      end

      let!(:product) { create(:product) }

      it 'destroys an user' do
        expect { subject }.to change(Product, :count).from(1).to(0)
      end
    end
  end
end
