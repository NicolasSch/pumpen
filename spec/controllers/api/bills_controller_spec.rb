# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::BillsController, type: :controller do
  before { authenticate }

  describe '#create' do
    subject { post :create }

    let!(:user) { create(:user) }
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
end
