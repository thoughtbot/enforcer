Feature: Set hooks

  Scenario: Adding a single collaborator for a specific project
    When I execute the following code
     """
     Enforcer "thoughtbot", "deadbeef" do
       postreceive "shoulda", "http://ci.thoughtbot.com"
     end
     """
    Then the GitHub API should have received a request to add "http://ci.thoughtbot.com" as a post-receive url for "shoulda"
