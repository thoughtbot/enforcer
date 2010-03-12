Feature: Manage collaborators
  Background:
    Given an account "thoughtbot" with an api key of "deadbeef"

  Scenario: Adding a single collaborator for a specific project
    Given I have the following "enforcer.yml" file:
     """
     key: deadbeef
     projects:
       shoulda:
         - rmmt
     """
    When I run enforcer on "enforcer.yml"
    Then the GitHub API should have received a request to add "rmmt" as a collaborator for "shoulda"

  Scenario: Adding a single collaborator for more than one project
    Given I have the following "enforcer.yml" file:
     """
     key: deadbeef
     projects:
       shoulda:
         - rmmt
       factory_girl:
         - qrush
     """
    When I run enforcer on "enforcer.yml"
    Then the GitHub API should have received a request to add "rmmt" as a collaborator for "shoulda"
    Then the GitHub API should have received a request to add "qrush" as a collaborator for "factory_girl"

  Scenario: Adding more than one collaborators for a specific project
    Given I have the following "enforcer.yml" file:
     """
     key: deadbeef
     projects:
       shoulda:
         - rmmt
         - qrush
         - coreyhaines
     """
    When I run enforcer on "enforcer.yml"
    Then the GitHub API should have received a request to add "rmmt" as a collaborator for "shoulda"
    And the GitHub API should have received a request to add "coreyhaines" as a collaborator for "shoulda"
    And the GitHub API should have received a request to add "qrush" as a collaborator for "shoulda"

  Scenario: Removing one collaborator from the project
    Given "qrush" is a collaborator for "shoulda"
    And I have the following "enforcer.yml" file:
     """
     key: deadbeef
     projects:
       shoulda:
         - coreyhaines
     """
    When I run enforcer on "enforcer.yml"
    Then the GitHub API should have received a request to add "coreyhaines" as a collaborator for "shoulda"
    And the GitHub API should have received a request to remove "qrush" as a collaborator for "shoulda"
