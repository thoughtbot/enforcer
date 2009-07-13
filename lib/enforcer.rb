$:.unshift(File.dirname(__FILE__))
require 'github_api'

class Enforcer
  def initialize(user_name)
  end

  def project(project_name, &block)
    instance_eval(&block)
    return if @collaborators.nil?

    @collaborators.each do |collaborator|
      GitHubApi.add_collaborator(project_name, collaborator)
    end
  end

  def collaborators(*names)
    @collaborators = names
  end
end

def Enforcer(user_name, &block)
   enforcer = Enforcer.new(user_name)
   enforcer.instance_eval(&block)
end
