require 'rails_helper'

RSpec.describe Cart do
  before :each do
    @user = create(:user)
    @merchant = create(:merchant, user: @user)
    @item = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)
    @user2 = create(:user)
  end
  subject { Cart.new({ "#{@item.id}" => 2, "#{@item2.id}" => 3 }) }

  describe '#total_count' do
    it 'can calculate the total number of items it holds' do
      cart = Cart.new({ "#{@item.id}" => 2, "#{@item2.id}" => 3 })

      expect(cart.total_count).to eq(5)
    end
  end

  describe '#add_item' do
    it 'adds an item to its contents' do

      subject.add_item(@item.id)
      subject.add_item(@item2.id)
      expect(subject.contents).to eq({"#{@item.id}" => 3, "#{@item2.id}" =>4})

      subject.remove_item(@item2.id)

      expect(subject.contents).to eq({"#{@item.id}" => 3, "#{@item2.id}" =>3})
    end
  end

  describe '#add_item' do
    it 'adds an item to its contents' do

      subject.delete_item(@item.id)

      expect(subject.contents).to eq({"#{@item2.id}" =>3})
    end
  end

  describe '#count_of' do
    it 'returns count of all items in cart' do
      cart = Cart.new({})

      expect(cart.count_of(5)).to eq(0)
    end
  end

end
