require 'csv'

module Admin
  class SepasController < AdminController
    def index
      @unexported_bills = Bill.for_sepa_export  
    end

    def create
      bills = Bill.for_sepa_export
      send_data(Sepa.export_xml(bills), filename: 'tab_invoices.xml')
    end

    def create_membership_invoices_xml
      membership_invoices = load_membership_invoices
      unless membership_invoices.map(&:valid?).include?(false)
        send_data Sepa.export_xml(membership_invoices),
                  filename: "#{membership_params[:file].original_filename.split('.').first}.xml"
      else
        @errors = membership_invoices.map do |invoice|
          next if invoice.errors.blank?
          "#{invoice.full_name}: #{invoice.errors.full_messages.join(', ')}"
        end.compact
        @unexported_bills = Bill.for_sepa_export
        flash[:error] = 'Fehler in Quelldatei'
        render :index
      end
    rescue ActionController::ParameterMissing
      @unexported_bills = Bill.for_sepa_export
      flash[:error] = 'Keine Datei ausgewählt'
      render :index
    end

    private

    def load_membership_invoices
      invoices = []
      CSV.foreach(membership_params[:file].path, headers: true) do |row|
        invoices << MembershipInvoice.new(
          firstname:row['First Name'],
          lastname: row['Last Name'],
          mandate_id: row['mandat ID'],
          membership_number: row['Member#'],
          date_of_signature: row['Date Signed'],
          email: row['Email'],
          bank: row['Bank'],
          bic: row['BIC'],
          iban: row['IBAN'],
          amount: row['Amount'].gsub(',', '.'),
          invoice_number: row['Invoice No.'],
          date_of_collection: row['Date of collection'],
          sequence_type: row['SEPA TRANSACTION']
        )
      end
      invoices
    end

    def sepa_params
      params.require(:sepa).permit(:filter)
    end

    def membership_params
      params.require(:membership_invoice).permit(:file)
    end
  end
end