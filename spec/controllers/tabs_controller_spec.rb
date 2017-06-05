require 'rails_helper'

RSpec.describe TabsController, type: :controller do
  let(:user)     { create(:user, :not_admin) }
  let(:manager)  { create(:user, :is_manager) }
  let(:admin)    { create(:user, :is_admin) }

  describe '#index' do
    subject {  get :index }

    context 'signed_in' do
      describe 'view specs' do
        render_views
        context 'user is manager' do
          before(:each) { sign_in(manager) }

          it 'does render add_item partial' do
            expect(subject).to render_template(partial: '_add_item')
          end

          context 'user is not manager' do
            before(:each) { sign_in(user) }

            it 'does not render add_item partial' do
              expect(subject).not_to render_template(partial: '_add_item')
            end
          end
        end
      end

      context 'tab exists' do
        let!(:older_tab) { create(:tab, user: manager, month: Time.now.month - 1 ) }
        let!(:tab)       { create(:tab, user: manager, month: Time.now.month) }

        before(:each) { sign_in(manager) }

        it 'uses existing tab' do
          expect{ subject }.not_to change { Tab.count }
        end

        it 'renders users current tab of the month' do
          subject
          expect(assigns(:tab)).to eq(tab)
        end
      end

      context 'tab does not exist' do
        before(:each) { sign_in(user) }

        it 'creates a new tab' do
          expect{ subject }.to change { Tab.count }.from(0).to(1)
        end
      end
    end
  end

  describe '#update' do
    context 'signed_in' do
      let(:product) { create(:product) }
      let!(:tab)    { create(:tab, user: manager, month: Time.now.month) }
      subject       { put :update, params: { id: tab.id, product_id: product.id } }

      before(:each) { sign_in(manager) }

      context 'user is manager' do
        describe 'adds cart_items to users current tab of the month' do
          it 'redirects to product path' do
            expect(subject).to redirect_to(:root)
          end

          it 'adds new items' do
            subject
            expect(tab.reload.tab_items.count).to eq(1)
            expect(tab.reload.tab_items.first.product).to eq(product)
          end

          it 'increases quantity of existing items' do
            tab.tab_items.create!(product: product)
            subject
            expect(tab.reload.tab_items.where(product: product).first.quantity).to eq(2)
          end
        end
      end

      context 'user is not manager' do
        it 'redirects to root with error' do
          manager.update!(membership: 'one')
          expect(subject).to redirect_to(:root)
          expect(flash[:alert]).to eq(I18n.translate('access_denied'))
        end
      end

      context 'different user' do
        before(:each) { sign_in(user) }
        it 'redirects to root with error' do
          manager.update!(membership: 'one')
          expect(subject).to redirect_to(:root)
          expect(flash[:alert]).to eq(I18n.translate('not_found'))
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
