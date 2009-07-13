class GitHubApi
  def self.add_collaborator(repo, collaborator)
    ["qrush", collaborator]
  end
end
