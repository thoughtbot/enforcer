Feature: Manage collaborators
  Background:
    Given an account "thoughtbot" with an api key of "deadbeef"

  Scenario: Adding a single collaborator for a specific project
    When I execute the following code
     """
     Enforcer "thoughtbot", "deadbeef" do
       project "shoulda" do
         collaborators 'rmmt'
       end
     end
     """
    Then the GitHub API should have received a request to add a "rmmt" as a collaborator for "shoulda"

  Scenario: Adding more than one collaborators for a specific project
    When I execute the following code
     """
     Enforcer "thoughtbot", "deadbeef" do
       project "shoulda" do
         collaborators 'rmmt', 'coreyhaines', 'qrush'
       end
     end
     """
    Then the GitHub API should have received a request to add a "rmmt" as a collaborator for "shoulda"
    And the GitHub API should have received a request to add a "coreyhaines" as a collaborator for "shoulda"
    And the GitHub API should have received a request to add a "qrush" as a collaborator for "shoulda"
