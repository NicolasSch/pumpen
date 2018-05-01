# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::RemindersController, type: :controller do
  before { authenticate }

  describe '#create' do
    subject { post :create }

    let!(:user) { create(:user) }
    let!(:tab)  { create(:tab, month: Time.zone.now.month - 1) }
    let!(:bill) { create(:bill, tab: tab, user: user) }

    it 'sets reminded at' do
      subject
      expect(bill.reload.reminded_at).not_to be nil
    end

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
end
