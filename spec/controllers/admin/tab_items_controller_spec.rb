# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TabItemsController, type: :controller do
  let!(:user) { create(:user, :is_admin) }

  describe '#create' do
    describe 'signed_in' do
      before { sign_in(user) }

      describe 'adds cart_items to users cart' do
        let!(:product)  { create(:product) }
        let!(:cart)     { create(:cart, user: user) }
        let(:request)   { post :create, params: { tab_item: { product_id: product.id, cart_id: cart.id } }, format: :js }
        let(:request_with_quantity) do
          post :create, params: { tab_item: { product_id: product.id, quantity: 3, cart_id: cart.id }, format: :js }
        end

        it 'is successful' do
          expect(request).to be_successful
        end

        it 'adds new item without quantity' do
          request
          expect(cart.reload.cart_items.count).to eq(1)
          expect(cart.reload.cart_items.first.quantity).to eq(1)
        end

        it 'adds new item with quantity n' do
          request_with_quantity
          expect(cart.reload.cart_items.count).to eq(1)
          expect(cart.reload.cart_items.first.quantity).to eq(3)
        end

        describe 'with existing item' do
          before { cart.cart_items.create!(product: product) }

          it 'increases quantity of existing items by 1' do
            request
            expect(cart.reload.cart_items.count).to eq(1)
            expect(cart.reload.cart_items.first.quantity).to eq(2)
          end

          it 'increases quantity of existing items by n' do
            request_with_quantity
            expect(cart.reload.cart_items.count).to eq(1)
            expect(cart.reload.cart_items.first.quantity).to eq(4)
          end
        end
      end
    end

    describe 'logged out' do
      it 'redirects to login page' do
        put :update, params: { id: 111 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
