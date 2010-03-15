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

    context "github is down" do
      should "not fail on api methods" do
        stub(Repository).get(anything, anything) { raise TimeoutError.new("Failwhale!") }
        assert_nothing_raised do
          @repo.list
        end
      end
    end

    context "adding postreceive hook" do
      setup do
        @response = "Accepted!"
        FakeWeb.register_uri(:post, "https://github.com/#{@account}/#{@project}/edit/postreceive_urls", :body => @response)
      end

      should "submit form data to github" do
        assert_equal @response, @repo.postreceive('http://example.com')
      end
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

    context "calling the API a lot in one minute" do
      setup do
        now = Time.now
        stub(Time).now { now }
        @repo.reset_counter
      end

      teardown do
        @repo.reset_counter
      end

      should "keep track in the api counter" do
        65.times{ @repo.tick_api_counter! }
        assert_equal 65, @repo.hit_count
        assert @repo.too_many_api_hits?
      end

      should "make sure the time remaining is correct if we go over" do
        65.times{ @repo.tick_api_counter! }

        now = Time.now + 10
        stub(Time).now { now }

        assert @repo.too_many_api_hits?
        assert_equal 50, @repo.remaining_seconds
      end

      should "reset after a minute passes" do
        65.times{ @repo.tick_api_counter! }
        now = Time.now + 61
        stub(Time).now { now }
        @repo.tick_api_counter! 
        assert_equal 1, @repo.hit_count
        assert ! @repo.too_many_api_hits?
      end
    end
  end
end
