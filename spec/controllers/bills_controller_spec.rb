require 'rails_helper'

RSpec.describe Admin::BillsController, type: :controller do
  let!(:user) { create(:user, :is_admin) }

  describe '#index' do
    describe 'signed_in' do
      context 'is admin' do
        let!(:tab_with_item)  { create(:tab, :with_tab_item, month: Time.now.month - 1, user: user) }
        let!(:tab_empty)      { create(:tab, month: Time.now.month - 1 ) }

        before(:each) { sign_in(user) }

        subject { get :index }

        it 'creates link to create bills for tabs with tab_items' do
          subject
          expect(assigns(:unbilled_tabs).count).to eq(1)
          expect(assigns(:unbilled_tabs).first).to eq(tab_with_item)
        end
      end

      context 'not admin' do
        before(:each) { sign_in(create(:user, :not_admin)) }

        it 'it redirects to root if not admin' do
          get :index
          expect(response).to redirect_to :root
          expect(flash[:notice]).to eq('Zugriff verweigert')
        end
      end
    end

    describe 'logged out' do
      it 'redirects to login page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
