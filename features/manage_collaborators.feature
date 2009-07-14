Feature: Manage collaborators
  Background:
    Given an account "thoughtbot" with an api key of "deadbeef"

  Scenario: Adding a single collaborator for a specific project
    When I execute the following code
     """
     Enforcer "thoughtbot", "deadbeef" do
       project "shoulda", 'rmmt'
     end
     """
    Then the GitHub API should have received a request to add "rmmt" as a collaborator for "shoulda"

  Scenario: Adding a single collaborator for more than one project
    When I execute the following code
     """
     Enforcer "thoughtbot", "deadbeef" do
       project "shoulda", 'rmmt'
       project "factory_girl", 'qrush'
     end
     """
    Then the GitHub API should have received a request to add "rmmt" as a collaborator for "shoulda"
    Then the GitHub API should have received a request to add "qrush" as a collaborator for "factory_girl"

  Scenario: Adding more than one collaborators for a specific project
    When I execute the following code
     """
     Enforcer "thoughtbot", "deadbeef" do
       project "shoulda", 'rmmt', 'coreyhaines', 'qrush'
     end
     """
    Then the GitHub API should have received a request to add "rmmt" as a collaborator for "shoulda"
    And the GitHub API should have received a request to add "coreyhaines" as a collaborator for "shoulda"
    And the GitHub API should have received a request to add "qrush" as a collaborator for "shoulda"

  Scenario: Removing one collaborator from the project
    Given "qrush" is a collaborator for "shoulda"
    When I execute the following code
     """
     Enforcer "thoughtbot", "deadbeef" do
       project "shoulda", 'coreyhaines'
     end
     """
    Then the GitHub API should have received a request to add "coreyhaines" as a collaborator for "shoulda"
    And the GitHub API should have received a request to remove "qrush" as a collaborator for "shoulda"
