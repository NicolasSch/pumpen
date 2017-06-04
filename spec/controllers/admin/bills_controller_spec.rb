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

  describe '#create' do
    describe 'signed_in' do
      context 'is admin' do
        let!(:tab_current)    { create(:tab, :with_tab_item, month: Time.now.month, user: user) }
        let!(:tab_with_item)  { create(:tab, :with_tab_item, month: Time.now.month - 1, user: user) }
        let!(:tab_empty)      { create(:tab, month: Time.now.month - 1 ) }

        before(:each) { sign_in(user) }

        subject { post :create }

        it 'creates a bill for tabs of last month' do
          expect{ subject }.to change { Bill.count }.from(0).to(1)
        end

        it 'destroys tab with no items' do
          expect{ subject }.to change { Tab.count }.from(3).to(2)
          expect(Tab.where(id: tab_empty.id).first).to be_nil
        end

        it 'does not create bill for users current tab' do
          subject
          expect(Bill.where(tab: tab_current)).to be_empty
        end

        it 'marks tab as billed' do
          subject
          expect(tab_with_item.reload.state).to eq('billed')
        end

        it 'sets amount as tab`s total price' do
          subject
          expect(Bill.first.amount).to eq(tab_with_item.total_price)
        end

        let(:items) { Bill.first.items }
        it 'serializes tab_items' do
          subject
          expect(items.count).to eq(1)
          expect(items.first[:title]).to eq(tab_with_item.tab_items.first.product.title)
          expect(items.first[:quantity]).to eq(tab_with_item.tab_items.first.quantity)
          expect(items.first[:price]).to eq(tab_with_item.tab_items.first.total_price)
        end
      end

      context 'not admin' do
        before(:each) { sign_in(create(:user, :not_admin)) }

        it 'it redirects to root if not admin' do
          post :create
          expect(response).to redirect_to :root
          expect(flash[:notice]).to eq('Zugriff verweigert')
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

  describe '#update' do
    describe 'signed_in' do
      context 'is admin' do
        let!(:tab) { create(:tab, month: Time.now.month - 1 ) }
        let!(:bill) { create(:bill, tab: tab) }

        before(:each) { sign_in(user) }

        subject { put :update , params: { id: bill.id} }

        it 'marks bill as paid' do
          subject
          expect(bill.reload.paid).to be true
        end

        it 'marks tab as closed' do
          subject
          expect(tab.reload.state).to eq('closed')
        end
      end

      context 'not admin' do
        before(:each) { sign_in(create(:user, :not_admin)) }

        it 'it redirects to root if not admin' do
          put :update , params: { id: 666 }
          expect(response).to redirect_to :root
          expect(flash[:notice]).to eq('Zugriff verweigert')
        end
      end
    end

    describe 'logged out' do
      it 'redirects to login page' do
        put :update , params: { id: 999 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
