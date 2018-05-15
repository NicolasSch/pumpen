module Xml
  class XmlBuilder
    def self.create(data)
      Nokogiri::XML::Builder.new do |xml|
        xml.DrctDbTxInf {
          xml.PmtId {
            xml.EndToEndId data.membership_number
          }
          xml.InstdAmt({Ccy: 'EUR'}, data.amount)
          xml.DrctDbTx {
            xml.MndtRltdInf {
              xml.MndtId data.mndt_id
              xml.DtOfSgntr data.date_of_signature
              xml.AmdmntInd data.amdmnt_id
            }
          }
          xml.DbtrAgt {
            xml.FinInstnId {
              xml.BIC data.bic
            }
          }
          xml.Dbtr {
            xml.Nm data.full_name
          }
          xml.DbtrAcct {
            xml.Id {
              xml.IBAN data.iban
            }
          }
          xml.RmtInf {
            xml.RmtInf {
              xml.Ustrd data.description
            }
          }
        }
      end
    end
  end
end
