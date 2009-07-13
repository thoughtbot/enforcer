require 'test_helper'

class GitHubApiTest < Test::Unit::TestCase

  context "adding collaborators" do
    setup do
      @repo = "repo"
      @user = "coreyhaines" + rand(10).to_s
      @collaborators = '{"collaborators": ["qrush", "'+ @user +'"]}'
      stub(GitHubApi).post("http://github.com/api/v2/json/repos/collaborators/#{@repo}/add/#{@user}") { @collaborators }
    end

    should "hit the github api" do
      collaborators = GitHubApi.add_collaborator(@repo, @user)
      assert_equal ["qrush",@user], collaborators
    end
  end

end

