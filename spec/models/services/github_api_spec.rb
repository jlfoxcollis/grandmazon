require 'rails_helper'

feature 'External request' do
  # it 'queries FactoryGirl contributors on Github' do
  #   stub_request(:get, /api.github.com/).
  #   with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
  #   to_return(status: 200, body: "stubbed response", headers: {})
  #
  #   uri = URI('https://api.github.com/repos/thoughtbot/factory_girl/contributors')
  #
  #   response = Net::HTTP.get(uri)
  #
  #   expect(response).to be_an_instance_of(String)
  # end

  describe 'can return name of repo' do
    let(:user_response) do
      VCR.use_cassette("github-api") do
        GrandmazonApiService.call("")

        expect(response).to eq("little-esty-shop")
      end
    end
  end

  # it 'can return commit count of repo' do
  #   stub_request(:any, /api.github.com/).
  #          with(
  #            headers: {
  #           'Accept'=>'*/*',
  #           'User-Agent'=>'Ruby'
  #            }).
  #          to_return(status: 200, body: "32", headers: {})
  #   uri = URI("https://api.github.com/repos/elyhess/little-esty-shop/commits")
  #   response = Net::HTTP.get(uri).to_i
  #
  #   expect(response).to eq(32)
  # end
  #
  # it 'can return PR count of repo' do
  #   stub_request(:any, /api.github.com/).
  #          with(
  #            headers: {
  #           'Accept'=>'*/*',
  #           'User-Agent'=>'Ruby'
  #            }).
  #          to_return(status: 200, body: "6", headers: {})
  #   uri = URI("https://api.github.com/repos/elyhess/little-esty-shop/Pulls?state=closed")
  #   response = Net::HTTP.get(uri).to_i
  #
  #   expect(response).to eq(6)
  # end
  #
  # it 'can return collaborators of repo' do
  #   collabs = ["Ely", "Sam", "Phil", "James"]
  #   stub_request(:any, /api.github.com/).
  #          with(
  #            headers: {
  #           'Accept'=>'*/*',
  #           'User-Agent'=>'Ruby'
  #            }).
  #          to_return(status: 200, body: collabs, headers: {})
  #   uri = URI("https://api.github.com/repos/elyhess/little-esty-shop/collaborators")
  #   response = Net::HTTP.get(uri)
  #
  #   expect(response).to eq(collabs)
  # end
end
