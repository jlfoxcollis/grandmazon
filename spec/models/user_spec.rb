require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it {should have_one :merchant }
  end

  describe 'relationships' do
    it {should have_one :merchant}
    it {should have_one :customer }
  end

  describe 'instance methods' do
    it 'can return a collection' do
      expect(enum_collection_for_select(User.roles, include_blank = false).flatten.uniq).to eq(["Merchant", "merchant", "Admin", "admin"])
    end
  end
end
