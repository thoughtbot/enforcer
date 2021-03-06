$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'httparty'
require 'json'

require 'enforcer/repository'

class Enforcer
  VERSION = "0.1.1"

  def initialize(account_name, api_key)
    @account_name = account_name
    @api_key = api_key
  end

  def project(project_name, *collaborators)
    return if collaborators.nil?

    repo = Repository.new(@account_name, @api_key, project_name)

    existing_collaborators = repo.list

    if existing_collaborators.nil?
      STDOUT.puts ">> Can't find existing collaborators for this project"
      return
    end

    { :add => collaborators - existing_collaborators,
      :remove => existing_collaborators - collaborators}.each_pair do |action, group|
        group.each do |collaborator|
          repo.send(action, collaborator)
        end
      end
  end

  def postreceive(project_name, *urls)
    repo = Repository.new(@account_name, @api_key, project_name)
    repo.postreceive(urls)
  end
end

def Enforcer(account_name, api_key, &block)
  enforcer = Enforcer.new(account_name, api_key)
  enforcer.instance_eval(&block)
end
