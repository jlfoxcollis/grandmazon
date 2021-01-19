# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'factory_bot'
FactoryBot.find_definitions

InvoiceItem.destroy_all
Item.destroy_all
Transaction.destroy_all
Invoice.destroy_all
Merchant.destroy_all
User.destroy_all

@admin = FactoryBot.create(:user, admin: true, email: "admin@example.com", password: "password", password_confirmation: "password")
20.times do
  @user = FactoryBot.create(:user)
  @merchant = FactoryBot.create(:merchant, name: @user.name, user: @user)
  FactoryBot.create(:discount, merchant: @merchant)
  FactoryBot.create(:discount, name: Faker::TvShows::StrangerThings.character, percentage: Faker::Number.between(from: 15, to: 50), minimum: Faker::Number.between(from: 6, to: 20), merchant: @merchant)

  10.times do
    FactoryBot.create(:item, merchant: @merchant)
  end
  @user2 = FactoryBot.create(:user)
  5.times do
    Invoice.create(status: Faker::Number.between(from: 0, to: 2), user: @user)
  end
end


5.times do
  Invoice.all.each do |invoice|
    item = Item.all.sample
    FactoryBot.create(:invoice_item, invoice: invoice, item: item, unit_price: item.unit_price)
    FactoryBot.create(:transaction, invoice: invoice)
  end
end
