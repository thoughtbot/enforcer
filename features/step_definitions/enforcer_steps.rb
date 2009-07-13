Given /^I am adding "(.*)" as a collaborator to "(.*)"$/ do |user, repo, code|
  @names << user
  @names_list = @names.join('", "')
  @collaborators = '{"collaborators: + ["' + @names_list + '"]}'

  mock(GitHubApi).add_collaborator(repo, user)
#  FakeWeb.register_uri(:post, "http://github.com/api/v2/json/repos/collaborators/#{@repo}/#{@user}", :string => @collaborators)
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
  assert_received(GitHubApi) { |subject| subject.add_collaborator(repo, user) }
end

