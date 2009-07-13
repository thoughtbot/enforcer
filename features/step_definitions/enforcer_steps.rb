Before do
  @repo = "repo"
  @existing_collaborators = []

  stub(Repository).new(anything, anything, anything) { @repo }
  stub(@repo).add(anything)
  stub(@repo).remove(anything)
  stub(@repo).list { @existing_collaborators }
end

Given /^an account "(.*)" with an api key of "(.*)"$/ do |account, api_key|
  @account = account
  @api_key = api_key
end

Given /^"([^\"]*)" is a collaborator for "([^\"]*)"$/ do |user, repo|
  @existing_collaborators << user
end

When /^I execute the following code$/ do |code|
  eval(code)
end

Then /^the GitHub API should have received a request to add a "(.*)" as a collaborator for "(.*)"$/ do |user, repo|
  assert_received(@repo) { |subject| subject.add(user) }
end

Then /^the GitHub API should have received a request to remove "([^\"]*)" as a collaborator for "([^\"]*)"$/ do |user, repo|
  assert_received(@repo) { |subject| subject.remove(user) }
end
