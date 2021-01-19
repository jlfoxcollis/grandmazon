class GitRepoStats

  def service
    GrandmazonApiService.new
  end

  def repo_name
    service.call("")[:name]
  end


  def pr_count
    service.pulls.count
  end

  def names
    hash = Hash.new(0)
    service.commits.each do |commit|
      if hash.include?(commit[:author][:login])
        hash[commit[:author][:login]] += 1
      else
        hash[commit[:author][:login]] = 1
      end
    end
    hash
  end
end
