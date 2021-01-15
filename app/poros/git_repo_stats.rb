class GitRepoStats

  def service
    GithubApi.new
  end

  def repo_name
    service.call("")
  end


  def pr_count
    service.pulls.count
  end

  # def names
  #   service.commits.map do |commit|
  #     [commit[:author], commit[:author][:login]]
  #   end.uniq
  # end
end
