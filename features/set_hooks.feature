Feature: Set hooks

  @wip
  Scenario: Adding a hook to a project
    When I execute the following code
     """
     Enforcer "thoughtbot", "deadbeef" do
       postreceive "shoulda", "http://ci.thoughtbot.com"
     end
     """
    Then the GitHub API should have received a request to add "http://ci.thoughtbot.com" as a post-receive url for "shoulda"

  @wip
  Scenario: Adding hooks to a project
    When I execute the following code
     """
     Enforcer "thoughtbot", "deadbeef" do
       postreceive "shoulda", "http://ci.thoughtbot.com", "http://rdoc.info/projects/update"
     end
     """
    Then the GitHub API should have received a request to add "http://ci.thoughtbot.com" as a post-receive url for "shoulda"
    Then the GitHub API should have received a request to add "http://rdoc.info/projects/update" as a post-receive url for "shoulda"
