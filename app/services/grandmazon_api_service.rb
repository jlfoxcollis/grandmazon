class GrandmazonApiService
  def conn
    Faraday.new(url: "https://api.github.com")
  end

  def call(arg)
    response = conn.get("/repos/jlfoxcollis/grandmazon#{arg}")
    github = JSON.parse(response.body, :symbolize_names => true)
  end

  def pulls
    call("/pulls?state=closed")

  end

  def commits
    call("/commits")
  end

  def commits_by_author(name)
    call("/commits?author=#{name}&per_page=100")
  end

end
