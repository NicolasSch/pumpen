# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::BillsController, type: :controller do
  let!(:user) { create(:user, :is_admin) }

  describe '#index' do
    describe 'signed_in' do
      context 'when user is admin' do
        subject { get :index }

        let!(:tab_with_item) { create(:tab, :with_tab_item, created_at: Time.zone.now - 1.month, user: user) }

        before do
          sign_in(user)
          create(:tab, created_at: Time.zone.now - 1.month)
        end

        it 'creates link to create bills for tabs with tab_items' do
          subject
          expect(assigns(:unbilled_tabs).count).to eq(1)
          expect(assigns(:unbilled_tabs).first).to eq(tab_with_item)
        end
      end

      context 'when user is not admin' do
        before { sign_in(create(:user, :not_admin)) }

        it 'redirects to root if not admin' do
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
      context 'when user is admin' do
        subject { post :create }

        let!(:tab_current)    { create(:tab, :with_tab_item, created_at: Time.zone.now, user: user) }
        let!(:tab_with_item)  { create(:tab, :with_tab_item, created_at: Time.zone.now - 1.month, user: user) }
        let!(:tab_empty)      { create(:tab, created_at: Time.zone.now - 1.month) }
        let(:items) { Bill.first.items }

        before { sign_in(user) }

        it 'creates a bill for tabs of last month' do
          expect { subject }.to change(Bill, :count).from(0).to(1)
        end

        it 'assigns tab_id to bill' do
          subject
          expect(Bill.first.tab_id).to eq tab_with_item.id
        end

        it 'assigns a number bill' do
          subject
          expect(Bill.first.number).to eq "RG-#{Bill.first.tab.id}-#{Bill.first.tab.created_at.year % 100}#{Bill.first.tab.month}"
        end

        it 'destroys tab with no items' do
          expect { subject }.to change(Tab, :count).from(3).to(2)
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

        it 'serializes tab_items' do
          subject
          expect(items.count).to eq(1)
          expect(items.first[:title]).to eq(tab_with_item.tab_items.first.product.title)
          expect(items.first[:quantity]).to eq(tab_with_item.tab_items.first.quantity)
          expect(items.first[:price]).to eq(tab_with_item.tab_items.first.total_price)
        end

        it 'queues an bill_added notification mail', perform_enqueued: true do
          expect(NotificationMailer).to receive(:bill_added).twice.and_call_original

          perform_enqueued_jobs do
            subject
            expect(ActionMailer::Base.deliveries.size).to eq(2)
            delivered_email = ActionMailer::Base.deliveries.first
            assert_includes delivered_email.to, user.email
          end
        end

        it 'queues an accounting_bills_summary_mail notification mail', perform_enqueued: true do
          expect(NotificationMailer).to receive(:accounting_bills_summary_mail).twice.and_call_original

          perform_enqueued_jobs do
            subject
            expect(ActionMailer::Base.deliveries.size).to eq(2)
            delivered_email = ActionMailer::Base.deliveries.last
            assert_includes delivered_email.to, NotificationMailer::ACCOUNTING_MAIL_ADDRESS
          end
        end
      end

      context 'when not admin' do
        before { sign_in(create(:user, :not_admin)) }

        it 'redirects to root if not admin' do
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
      context 'when user is admin' do
        subject { put :update, params: { id: bill.id } }

        let!(:tab) { create(:tab, created_at: Time.zone.now - 1.month) }
        let!(:bill) { create(:bill, tab: tab) }

        before { sign_in(user) }

        it 'marks bill as paid' do
          subject
          expect(bill.reload.paid).to be true
        end

        it 'marks tab as closed' do
          subject
          expect(tab.reload.state).to eq('closed')
        end
      end

      context 'when user is not admin' do
        before { sign_in(create(:user, :not_admin)) }

        it 'redirects to root if not admin' do
          put :update, params: { id: 666 }
          expect(response).to redirect_to :root
          expect(flash[:notice]).to eq('Zugriff verweigert')
        end
      end
    end

    describe 'logged out' do
      it 'redirects to login page' do
        put :update, params: { id: 999 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
