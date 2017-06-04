require 'rails_helper'

RSpec.describe Admin::CartsController, type: :controller do
  let!(:admin) { create(:user, :is_admin) }
  let!(:user) { create(:user, :not_admin) }

  describe '#update' do
    describe 'signed_in' do

      context 'is admin' do
        before(:each) { sign_in(admin) }

        describe 'adds cart_items to users current tab of the month' do
          let!(:cart) { create(:cart, :with_cart_items, user: user ) }
          subject     { put :update, params: { id: cart.id } }

          describe 'tab exists' do
            let!(:tab)  { create(:tab, :with_tab_item, month: Time.now.month, user: user) }

            it 'uses existing tab' do
              expect{ subject }.not_to change { Tab.count }
            end

            it 'redirects to product path' do
              expect(subject).to redirect_to(admin_shops_path)
            end

            it 'destroys cart' do
              expect{ subject }.to change{ Cart.count }.from(1).to(0)
            end

            it 'adds new items' do
              subject
              expect(Tab.first.tab_items.count).to eq(3)
            end

            it 'increases quantity of existing items' do
              product = tab.tab_items.first.product
              cart.cart_items.create!(product: product)
              subject
              expect(TabItem.where(product: product).first.quantity).to eq(2)
            end

            it 'queues an tab_items_add notification mail', perform_enqueued: true do
              expect(NotificationMailer).to receive(:tab_items_added).twice.and_call_original

              perform_enqueued_jobs do
                subject
                expect(ActionMailer::Base.deliveries.size).to eq(1)
                delivered_email = ActionMailer::Base.deliveries.last
                assert_includes delivered_email.to, user.email
              end
            end
          end

          describe 'tab does not exist' do
            it 'creates a new tab' do
              expect{ subject }.to change { Tab.count }.from(0).to(1)
            end
          end
        end

        context 'is not admin' do
          before(:each) { sign_in(user) }

          it 'it redirects to root if not admin' do
            put :update , params: { id: 666 }
            expect(response).to redirect_to :root
            expect(flash[:notice]).to eq('Zugriff verweigert')
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
