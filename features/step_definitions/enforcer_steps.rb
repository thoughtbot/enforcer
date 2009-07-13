Given /^an account "(.*)" with an api key of "(.*)"$/ do |account, api_key|
  @account = account
  @api_key = api_key
end

Given /^I am adding "(.*)" as a collaborator to "(.*)"$/ do |user, repo, code|
  @names << user
  @names_list = @names.join('", "')
  @collaborators = '{"collaborators: + ["' + @names_list + '"]}'

  mock(GitHubApi).add_collaborator(@account, @api_key, repo, user)
  @code = code
end

When /^I execute it$/ do
  eval(@code)
end

Given /^the following collaborators for "([^\"]*)"$/ do |project_name, table|
  @names = []
  table.hashes.each do |collaborator|
    @names << collaborator[:name]
  end
end

Then /^the GitHub API should have received a request to add a "(.*)" as a collaborator for "(.*)"$/ do |user, repo|
  assert_received(GitHubApi) { |subject| subject.add_collaborator(@account, @api_key, repo, user) }
end

