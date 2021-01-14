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

  def names
    service.commits.map do |commit|
      commit[:author][:login]
    end.uniq
  end

  def commits_count
    hash = {}
    names.each do |name|
      hash[name] = service.commits_by_author(name).size
    end
    hash
  end
end
