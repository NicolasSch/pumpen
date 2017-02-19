raise 'seed.rb is not meant to be run in production' if Rails.env.production?

FactoryGirl.create(:user, :is_admin, email: 'admin@test.com') unless User.exists?(role: 'admin')
FactoryGirl.create(:user, :not_admin, email: 'user@test.com') unless User.exists?(role: 'user')
20.times { FactoryGirl.create(:product) } if Product.count.zero?
