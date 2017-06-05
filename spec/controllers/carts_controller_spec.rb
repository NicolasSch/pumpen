require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let!(:user) { create(:user, :is_manager) }

  describe '#update' do
    describe 'signed_in' do
      before(:each) { sign_in(user) }

      describe 'adds cart_items to users current tab of the month' do
        let!(:cart) { create(:cart, :with_cart_items, user: user ) }
        subject     { put :update, params: { id: cart.id } }

        describe 'tab exists' do
          let!(:tab)  { create(:tab, :with_tab_item, month: Time.now.month, user: user) }

          it 'uses existing tab' do
            expect{ subject }.not_to change { Tab.count }
          end

          it 'redirects to product path' do
            expect(subject).to redirect_to(products_path)
          end

          it 'adds new items' do
            subject
            expect(Tab.first.tab_items.count).to eq(3)
          end

          it 'destroys cart items' do
            subject
            expect(cart.reload.cart_items).to be_empty
          end

          it 'increases quantity of existing items' do
            product = tab.tab_items.first.product
            cart.cart_items.create!(product: product)
            subject
            expect(TabItem.where(product: product).first.quantity).to eq(2)
          end
        end

        describe 'tab does not exist' do
          it 'creates a new tab' do
            expect{ subject }.to change { Tab.count }.from(0).to(1)
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
