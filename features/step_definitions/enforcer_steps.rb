Before do
  @repo = "repo"
  @existing_collaborators = []

  stub(Repository).new(anything, anything, anything) { @repo }
  stub(@repo).add(anything)
  stub(@repo).remove(anything)
  stub(@repo).postreceive(anything)
  stub(@repo).list { @existing_collaborators }

  FileUtils.mkdir(TEST_DIR)
  Dir.chdir(TEST_DIR)
end

After do
  Dir.chdir(TEST_DIR)
  FileUtils.rm_rf(TEST_DIR)
end

Given /^an account "(.*)" with an api key of "(.*)"$/ do |account, api_key|
  @account = account
  @api_key = api_key
end

Given /^"([^\"]*)" is a collaborator for "([^\"]*)"$/ do |user, repo|
  @existing_collaborators << user
end

Given /^I have the following "([^\"]*)" file:$/ do |name, yaml|
  File.open(name, "w") do |f|
    f.write yaml
  end
end

When /^I run enforcer on "([^\"]*)"$/ do |file|
  Enforcer.enforce(file)
end

Then /^the GitHub API should have received a request to add "(.*)" as a collaborator for "(.*)"$/ do |user, repo|
  assert_received(@repo) { |subject| subject.add(user) }
end

Then /^the GitHub API should have received a request to remove "([^\"]*)" as a collaborator for "([^\"]*)"$/ do |user, repo|
  assert_received(@repo) { |subject| subject.remove(user) }
end

Then /^the GitHub API should have received a request to add "([^\"]*)" as a post\-receive url for "([^\"]*)"$/ do |url, repo|
  assert_received(@repo) { |subject| subject.postreceive(satisfy { |urls| urls.include?(url) }) }
end
