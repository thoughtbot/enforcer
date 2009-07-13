require 'httparty'
require 'json'

class GitHubApi
  include HTTParty
  base_uri 'http://github.com/api/v2/json'

  def self.add_collaborator(account, api_key, repo, collaborator)
    response = self.post "/repos/collaborators/#{repo}/add/#{collaborator}", :body => { :login => account, :token => api_key }
    response['collaborators']
  end

  def self.remove_collaborator(account, api_key, repo, collaborator)
    response = self.post "/repos/collaborators/#{repo}/remove/#{collaborator}", :body => { :login => account, :token => api_key }
    response['collaborators']
  end
  
  def self.list_collaborators(account, repo)
    response = self.get "/repos/show/#{account}/#{repo}/collaborators"
    response['collaborators']
  end
end
