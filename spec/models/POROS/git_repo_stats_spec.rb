require 'rails_helper'
describe GitRepoStats do
  it "exists" do
    user_repo = GitRepoStats.new

    expect(user_repo).to be_a(GitRepoStats)
  end

  it 'can repo name' do
    VCR.use_cassette("github_repo_name") do
      git_repo_stats = GitRepoStats.new

      expect(git_repo_stats.repo_name).to eq("grandmazon")
    end
  end

  it 'can repo PR count' do
    VCR.use_cassette("github_pr_count") do
      git_repo_stats = GitRepoStats.new

      expect(git_repo_stats.pr_count).to eq(3)
    end
  end

  it 'can collaborator names' do
    VCR.use_cassette("github_commits") do
      git_repo_stats = GitRepoStats.new

      expect(git_repo_stats.names).to eq({"jlfoxcollis" => 30})
    end
  end
end
