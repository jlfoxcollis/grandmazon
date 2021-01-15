require 'rails_helper'

feature 'repo test' do
  it 'can return name of repo' do
    stub_request(:any, /api.github.com/).
           with(
             headers: {
            'Accept'=>'*/*',
            'User-Agent'=>'Ruby'
             }).
           to_return(status: 200, body: "little-esty-shop", headers: {})
    uri = URI("https://api.github.com/repos/elyhess/little-esty-shop")
    response = Net::HTTP.get(uri)

    expect(response).to eq("little-esty-shop")
  end

  it 'can return commit count of repo' do
    stub_request(:any, /api.github.com/).
           with(
             headers: {
            'Accept'=>'*/*',
            'User-Agent'=>'Ruby'
             }).
           to_return(status: 200, body: "32", headers: {})
    uri = URI("https://api.github.com/repos/elyhess/little-esty-shop/commits")
    response = Net::HTTP.get(uri).to_i

    expect(response).to eq(32)
  end

  it 'can return PR count of repo' do
    stub_request(:any, /api.github.com/).
           with(
             headers: {
            'Accept'=>'*/*',
            'User-Agent'=>'Ruby'
             }).
           to_return(status: 200, body: "6", headers: {})
    uri = URI("https://api.github.com/repos/elyhess/little-esty-shop/Pulls?state=closed")
    response = Net::HTTP.get(uri).to_i

    expect(response).to eq(6)
  end

  it 'can return collaborators of repo' do
    collabs = ["Ely", "Sam", "Phil", "James"]
    stub_request(:any, /api.github.com/).
           with(
             headers: {
            'Accept'=>'*/*',
            'User-Agent'=>'Ruby'
             }).
           to_return(status: 200, body: collabs, headers: {})
    uri = URI("https://api.github.com/repos/elyhess/little-esty-shop/collaborators")
    response = Net::HTTP.get(uri)

    expect(response).to eq(collabs)
  end
end
