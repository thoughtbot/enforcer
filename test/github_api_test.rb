require 'test_helper'

class GitHubApiTest < Test::Unit::TestCase
  context "existence" do
    should "exist" do
      assert GitHubApi
    end
  end
end

