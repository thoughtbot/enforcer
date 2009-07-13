require 'test_helper'

class RepositoryTest < Test::Unit::TestCase
  context "with github api credentials" do
    setup do
      @account = "thoughtbot"
      @api_key = "deadbeef"
      @project = "project"
      @user    = "coreyhaines" + rand(10).to_s
      @repo    = Repository.new(@account, @api_key, @project)
    end

    should "set base uri" do
      assert_equal "http://github.com/api/v2/json/repos", Repository.base_uri
    end

    context "listing collaborators" do
      setup do
        @collaborators = ["qrush", "coreyhaines"]
        stub(Repository).get(anything, anything) { {'collaborators' => @collaborators} }
        @result = @repo.list
      end

      should "return just the usernames" do
        assert_equal @collaborators, @result
      end

      should "hit the github api" do
        assert_received(Repository) do |subject|
          subject.get("/show/#{@account}/#{@project}/collaborators", 
           :body => {:login => @account, :token => @api_key}) { { 'collaborators' => @collaborators } }
        end
      end
    end

    context "adding a collaborator" do
      setup do
        @collaborators = ["qrush", @user]
        stub(Repository).post(anything, anything) { {'collaborators' => @collaborators }}
        @collaborators = @repo.add(@user)
      end

      should "hit the github api" do
        assert_received(Repository) do |subject|
          subject.post("/collaborators/#{@project}/add/#{@user}", :body => {
            :login => @account,
            :token => @api_key})
        end
      end

      should "return the new collaborators" do
        assert_equal ["qrush", @user], @collaborators
      end
    end
    context "removing a collaborator" do
      setup do
        @collaborators = ["qrush"]
        stub(Repository).post(anything, anything) { {'collaborators' => @collaborators }}
        @result = @repo.remove(@user)
      end

      should "hit the github api" do
        assert_received(Repository) do |subject|
          subject.post("/collaborators/#{@project}/remove/#{@user}", :body => {
            :login => @account,
            :token => @api_key})
        end
      end

      should "return the new collaborators" do
        assert_equal ["qrush"], @result
      end
    end
  end
end
