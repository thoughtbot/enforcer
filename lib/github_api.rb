require 'httparty'
require 'json'

class GitHubApi
  include HTTParty
  base_uri 'http://github.com/api/v2/json'

  def self.add_collaborator(account, api_key, repo, collaborator)
    collaborator_list = self.post "/repos/collaborators/#{repo}/add/#{collaborator}", :login => account, :token => api_key
    collaborators = JSON.parse(collaborator_list)
    collaborators['collaborators']
  end
end
