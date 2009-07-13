Given /^we are capturing http requests$/ do
  stub(GitHubApi).add_collaborator(anything)
end

Given /^the following$/ do |code|
  @code = code
end

When /^I execute it$/ do
  eval(@code)
end

Then /^I should have made a request to add the collaborators$/ do |table|
  table.hashes.each do |collaborator|
    assert_received(GitHubApi) { |subject| subject.add_collaborator(collaborator[:name]) }
  end
end

