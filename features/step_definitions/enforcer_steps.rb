Before do
  stub(GitHubApi).add_collaborator(anything, anything, anything, anything)
  stub(GitHubApi).remove_collaborator(anything, anything, anything, anything)
  @existing_collaborators = []
  stub(GitHubApi).list_collaborators(anything, anything) { @existing_collaborators }
end


Given /^an account "(.*)" with an api key of "(.*)"$/ do |account, api_key|
  @account = account
  @api_key = api_key
end

# Given /^I am adding "(.*)" as a collaborator to "(.*)"$/ do |user, repo, code|
#   @names = []
#   @names << user
#   @names_list = @names.join('", "')
#   @collaborators = '{"collaborators: + ["' + @names_list + '"]}'
# 
#   mock(GitHubApi).add_collaborator(@account, @api_key, repo, user)
#   @code = code
# end

When /^I execute the following code$/ do |code|
  eval(code)
end


Then /^the GitHub API should have received a request to add a "(.*)" as a collaborator for "(.*)"$/ do |user, repo|
  assert_received(GitHubApi) { |subject| subject.add_collaborator(@account, @api_key, repo, user) }
end

Given /^"([^\"]*)" is a collaborator for "([^\"]*)"$/ do |user, repo|
  @existing_collaborators << user
end

Then /^the GitHub API should have received a request to remove "([^\"]*)" as a collaborator for "([^\"]*)"$/ do |user, repo|
  assert_received(GitHubApi) { |subject| subject.remove_collaborator(@account, @api_key, repo, user) }
end
