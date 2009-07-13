$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'httparty'
require 'json'

require 'repository'

class Enforcer
  def initialize(account_name, api_key)
    @account_name = account_name
    @api_key = api_key
  end

  def project(project_name, &block)
    instance_eval(&block)
    return if @collaborators.nil?

    STDOUT.puts "Enforcing settings for #{project_name}"
    repo = Repository.new(@account_name, @api_key, project_name)

    existing_collaborators = repo.list

    { :add => @collaborators - existing_collaborators,
      :remove => existing_collaborators - @collaborators}.each_pair do |action, collaborators|
        collaborators.each do |collaborator|
          repo.send(action, collaborator)
        end
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
