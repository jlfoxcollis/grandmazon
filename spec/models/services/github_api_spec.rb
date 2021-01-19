require 'rails_helper'


describe GrandmazonApiService do
  it "exists" do
    grandmazon_api_service = GrandmazonApiService.new

    expect(grandmazon_api_service).to be_a(GrandmazonApiService)
  end

  it 'gets info for github user' do
    VCR.use_cassette("grandmazon_pulls") do
      grandmazon_api_service = GrandmazonApiService.new

      pulls = grandmazon_api_service.pulls
      expect(pulls.count).to eq(3)
      expect(pulls.first[:user][:login]).to eq("jlfoxcollis")
    end
  end

  it 'gets info for github user' do
    VCR.use_cassette("grandmazon_commits") do
      grandmazon_api_service = GrandmazonApiService.new
      commits = grandmazon_api_service.commits

      expect(commits.count).to eq(30)
    end
  end

  it 'gets info for github user' do
    VCR.use_cassette("grandmazon_commits_by_author") do
      grandmazon_api_service = GrandmazonApiService.new
      by_author = grandmazon_api_service.commits_by_author("jlfoxcollis")

      expect(by_author.count).to eq(39)
      expect(by_author.first[:author][:login]).to eq("jlfoxcollis")
    end
  end
end
