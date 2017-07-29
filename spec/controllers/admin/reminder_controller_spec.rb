require 'rails_helper'

RSpec.describe Admin::ReminderController, type: :controller do
  let!(:user) { create(:user, :is_admin) }

  describe '#update' do
    describe 'signed_in' do
      context 'is admin' do
        let!(:tab) { create(:tab, month: Time.now.month - 1 ) }
        let!(:bill) { create(:bill, tab: tab, user: user) }

        before(:each) { sign_in(user) }

        subject { put :show , params: { bill_id: bill.id} }

        it 'queues an bill_added notification mail', perform_enqueued: true do
          expect(NotificationMailer).to receive(:open_bills_reminder).twice.and_call_original

          perform_enqueued_jobs do
            subject
            expect(ActionMailer::Base.deliveries.size).to eq(1)
            delivered_email = ActionMailer::Base.deliveries.last
            assert_includes delivered_email.to, user.email
          end
        end
      end

      context 'not admin' do
        before(:each) { sign_in(create(:user, :not_admin)) }

        it 'it redirects to root if not admin' do
          put :show , params: { bill_id: 666 }
          expect(response).to redirect_to :root
          expect(flash[:notice]).to eq('Zugriff verweigert')
        end
      end
    end

    describe 'logged out' do
      it 'redirects to login page' do
        put :show , params: { bill_id: 999 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
