require 'rails_helper'

RSpec.describe TabItemsController, type: :controller do
  let!(:user) { create(:user, :is_manager) }
  let!(:tab)  { create(:tab, user: user, month: Time.now.month) }

  describe '#create' do
    describe 'signed_in' do
      before(:each) { sign_in(user) }

      describe 'adds tab_item to users current tab' do
        let!(:product)  { create(:product) }
        let(:request)   { post :create, params: { tab_item: { product_id: product.id } } }
        let(:request_with_quantity) { post :create, params: { tab_item: { product_id: product.id, quantity: 3 } } }

        it 'is successful' do
          expect(request).to be_redirect
        end

        it 'adds new item without quantity' do
          request
          expect(tab.reload.tab_items.count).to eq(1)
          expect(tab.reload.tab_items.first.quantity).to eq(1)
        end

        it 'adds new item with quantity n' do
          request_with_quantity
          expect(tab.reload.tab_items.count).to eq(1)
          expect(tab.reload.tab_items.first.quantity).to eq(3)
        end

        describe 'with existing item' do
          let!(:item) { tab.tab_items.create!(product: product) }
          
          it 'increases quantity of existing items by n' do
            request_with_quantity
            expect(tab.reload.tab_items.count).to eq(1)
            expect(tab.reload.tab_items.first.quantity).to eq(4)
          end
        end
      end
    end

    describe 'logged out' do
      it 'redirects to login page' do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
