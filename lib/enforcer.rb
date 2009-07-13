$:.unshift(File.dirname(__FILE__))
require 'github_api'

class Enforcer
  def initialize(account_name, api_key)
    @account_name = account_name
    @api_key = api_key
  end

  def project(project_name, &block)
    instance_eval(&block)
    return if @collaborators.nil?

    @collaborators.each do |collaborator|
      GitHubApi.add_collaborator(@account_name, @api_key, project_name, collaborator)
    end
  end

  def collaborators(*names)
    @collaborators = names
  end
end

def Enforcer(account_name, api_key, &block)
  enforcer = Enforcer.new(account_name, api_key)
  enforcer.instance_eval(&block)
end
