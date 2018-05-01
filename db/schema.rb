# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_170_729_223_438) do
  create_table 'bills', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.datetime 'created_at',                                                        null: false
    t.datetime 'updated_at',                                                        null: false
    t.integer  'tab_id'
    t.string   'number', null: false
    t.boolean  'paid', default: false
    t.decimal  'amount', precision: 8, scale: 2, null: false
    t.text     'items', limit: 65_535
    t.integer  'discount'
    t.datetime 'reminded_at'
    t.index ['tab_id'], name: 'index_bills_on_tab_id', using: :btree
  end

  create_table 'carts', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.integer 'user_id', null: false
    t.index ['user_id'], name: 'index_carts_on_user_id', using: :btree
  end

  create_table 'products', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.datetime 'created_at',                                               null: false
    t.datetime 'updated_at',                                               null: false
    t.string   'title'
    t.decimal  'price', precision: 8, scale: 2, null: false
    t.string   'plu'
    t.integer  'product_group_id'
    t.string   'product_group'
    t.string   'product_type'
    t.boolean  'archived', default: false
  end

  create_table 'tab_items', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.datetime 'created_at',             null: false
    t.datetime 'updated_at',             null: false
    t.integer  'product_id'
    t.integer  'tab_id'
    t.integer  'quantity', default: 1
    t.integer  'cart_id'
    t.index ['cart_id'], name: 'index_tab_items_on_cart_id', using: :btree
    t.index ['product_id'], name: 'index_tab_items_on_product_id', using: :btree
    t.index ['tab_id'], name: 'index_tab_items_on_tab_id', using: :btree
  end

  create_table 'tabs', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.datetime 'created_at',                  null: false
    t.datetime 'updated_at',                  null: false
    t.integer  'user_id'
    t.integer  'month',      default: 4, null: false
    t.string   'state',      default: 'open'
    t.integer  'discount'
    t.index ['user_id'], name: 'index_tabs_on_user_id', using: :btree
  end

  create_table 'users', force: :cascade, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.string   'first_name'
    t.string   'last_name'
    t.string   'gender'
    t.string   'role', default: 'user', null: false
    t.string   'membership'
    t.string   'email',                  default: '',     null: false
    t.string   'encrypted_password',     default: '',     null: false
    t.string   'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer  'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string   'current_sign_in_ip'
    t.string   'last_sign_in_ip'
    t.string   'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string   'unconfirmed_email'
    t.datetime 'created_at',                              null: false
    t.datetime 'updated_at',                              null: false
    t.string   'street'
    t.string   'zip'
    t.string   'city'
    t.integer  'member_number'
    t.boolean  'archived', default: false
    t.index ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true, using: :btree
    t.index ['email'], name: 'index_users_on_email', unique: true, using: :btree
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree
  end

  add_foreign_key 'tab_items', 'products'
  add_foreign_key 'tab_items', 'tabs'
  add_foreign_key 'tabs', 'users'
end
