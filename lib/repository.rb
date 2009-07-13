require 'httparty'
require 'json'

class Repository
  include HTTParty
  base_uri 'http://github.com/api/v2/json/repos'

  def initialize(account, api_key, project)
    @account = account
    @project = project
    @api_key = api_key
  end

  def request(method, path)
    response = self.class.send(method, path, :body => { :login => @account, :token => @api_key })
    response['collaborators']
  end

  def list
    request(:get, "/show/#{@account}/#{@project}/collaborators")
  end

  def add(collaborator)
    request(:post, "/collaborators/#{@project}/add/#{collaborator}")
  end

  def remove(collaborator)
    request(:post, "/collaborators/#{@project}/remove/#{collaborator}")
  end
end
