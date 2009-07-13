Feature: Manage collaborators
  Background:
    Given an account "thoughtbot"

  Scenario: Adding a single collaborator for a specific project
    Given the following collaborators for "shoulda"
     |name      |
     |thoughtbot|
    Given I am adding "rmmt" as a collaborator to "shoulda"
     """
     Enforcer "thoughtbot" do
       project "shoulda" do
         collaborators 'rmmt'
       end
     end
     """
     When I execute it
     Then the GitHub API should have received a request to add a "rmmt" as a collaborator for "shoulda"

