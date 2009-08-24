class Repository
  include HTTParty
  base_uri 'http://github.com/api/v2/json/repos'

  HTTP_ERRORS = [Timeout::Error,
                 Errno::EINVAL,
                 Errno::ECONNRESET,
                 EOFError,
                 Net::HTTPBadResponse,
                 Net::HTTPHeaderSyntaxError,
                 Net::ProtocolError]

  def initialize(account, api_key, project)
    @account = account
    @project = project
    @api_key = api_key
  end

  def request(method, path)
    begin
      response = self.class.send(method, path, :body => { :login => @account, :token => @api_key })
      response['collaborators']
    rescue *HTTP_ERRORS => ex
      STDOUT.puts ">> There was a problem contacting GitHub: #{ex}"
    end
  end

  def list
    request(:get, "/show/#{@account}/#{@project}/collaborators")
  end

  def add(collaborator)
    STDOUT.puts ">> Adding #{collaborator}"
    request(:post, "/collaborators/#{@project}/add/#{collaborator}")
  end

  def remove(collaborator)
    STDOUT.puts ">> Removing #{collaborator}"
    request(:post, "/collaborators/#{@project}/remove/#{collaborator}")
  end
end
