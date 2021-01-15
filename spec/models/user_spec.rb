require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :last_name }
    it {should validate_presence_of :first_name }
  end

  describe 'relationships' do
    it {should have_many :invoices}
    it {should have_many(:transactions).through(:invoices) }
    it {should have_many(:invoice_items).through(:invoices) }
    it {should have_many(:items).through(:invoice_items) }
    # it {should have_many(:merchants).through(:items) }
    it {should have_one :merchant}
  end

  describe 'instance methods' do
    before :each do
      @user = create(:user)
      @merchant = create(:merchant, user: @user)

      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      @user4 = create(:user)
      @user5 = create(:user)
      @user6 = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      User.all.each do |user|
        create_list(:invoice, 1, user: user)
      end

      customer_list = [@user1, @user2, @user3, @user4, @user5, @user6]

      create_list(:transaction, 10, invoice: @user5.invoices.first, result: 0)

      customer_list.size.times do |i|
        create_list(:transaction, (i+1), invoice: customer_list[i].invoices.first, result: 1)
      end
    end

    it '#successful_purchases' do
      expect(@user1.successful_purchases).to eq(1)
      expect(@user3.successful_purchases).to eq(3)
      expect(@user2.successful_purchases).to eq(2)
      expect(@user5.successful_purchases).to eq(5)
    end
  end

  describe 'class methods' do
    before :each do
      @user = create(:user)
      @merchant = create(:merchant, user: @user)

      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      @user4 = create(:user)
      @user5 = create(:user)
      @user6 = create(:user)

      User.all.each do |user|
        create_list(:invoice, 1, user: user)
      end

      it '::top_five_customers' do
        customer_list = [@user1, @user2, @user3, @user4, @user5, @user6]

        create_list(:transaction, 10, invoice: @user5.invoices.first, result: 0)

        customer_list.size.times do |i|
          create_list(:transaction, (i+1), invoice: customer_list[i].invoices.first, result: 1)
        end

        expect(User.top_five_customers).to eq([@user6, @user5, @user4, @user3, @user2])
      end
    end
  end
end
