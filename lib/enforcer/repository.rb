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

  def postreceive(hook)
    auth = {:login => @account, :token => @api_key}

    url = URI.parse "https://github.com/#{@account}/#{@project}/edit/postreceive_urls"
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data({"urls[]" => hook}.merge(auth), '&')

    server = Net::HTTP.new url.host, url.port
    server.use_ssl = url.scheme == 'https'
    server.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = server.start {|http| http.request(req) }
    res.body
  end
end
