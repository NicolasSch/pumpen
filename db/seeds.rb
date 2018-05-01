# frozen_string_literal: true

raise 'seed.rb is not meant to be run in production' if Rails.env.production?

FactoryBot.create(:user, :is_admin, email: 'admin@test.com') unless User.exists?(role: 'admin')
FactoryBot.create(:user, :not_admin, email: 'user@test.com') unless User.exists?(role: 'user')
20.times { FactoryBot.create(:product) } if Product.count.zero?
