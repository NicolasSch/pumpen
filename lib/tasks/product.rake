# frozen_string_literal: true

require 'csv'

namespace :product do
  desc 'imports sumup csv export file'

  task import: :environment do
    file = 'db/data/products.csv'
    CSV.foreach(file, headers: true) do |row|
      product = Product.where(title: row['Artikel']).first
      if product
        product.update!(
          plu:              row['PLU'],
          price:            row['Preis'],
          title:            row['Artikel'],
          short_title:      row['Artikel (Kurzbezeichnung)'],
          product_group_id: row['Artikelgruppe ID'],
          product_group:    row['Artikelgruppe'],
          product_type:     row['Artikelart']
        )
        puts "Line #{$INPUT_LINE_NUMBER} - Artikel: #{row['Artikel']} updated"
      else
        Product.create!(
          plu:              row['PLU'],
          price:            row['Preis'],
          title:            row['Artikel'],
          short_title:      row['Artikel (Kurzbezeichnung)'],
          product_group_id: row['Artikelgruppe ID'],
          product_group:    row['Artikelgruppe'],
          product_type:     row['Artikelart']
        )
        puts "Line #{$INPUT_LINE_NUMBER} - Artikel: #{row['Artikel']} created"
      end
    end
  end
end
