require 'github_api'

class Enforcer

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
