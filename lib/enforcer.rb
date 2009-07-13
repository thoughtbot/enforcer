$:.unshift(File.dirname(__FILE__))
require 'github_api'

class Enforcer
  def initialize(account_name)
    @account_name = account_name
  end

  def project(project_name, &block)
    instance_eval(&block)
    return if @collaborators.nil?

    @collaborators.each do |collaborator|
      GitHubApi.add_collaborator(@account_name, project_name, collaborator)
    end
  end

  def collaborators(*names)
    @collaborators = names
  end
end

def Enforcer(account_name, &block)
  enforcer = Enforcer.new(account_name)
  enforcer.instance_eval(&block)
end
