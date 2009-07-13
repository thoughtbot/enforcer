Feature: Manage collaborators

  Background:
    Given we are capturing http requests

  Scenario: Adding a single collaborator for a specific project
    Given the following
    """
    project :name => "shoulda" do |p|
    p.collaborators << ['rmmt']
    end
    """
    When I execute it
    Then I should have made a request to add the collaborators
    |name|
    |rmmt|
