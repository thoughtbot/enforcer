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

  def tick_api_counter!
    now = Time.now
    @@last_access ||= now
    @@access_counter ||= 0
    reset_counter if now - @@last_access > 60
    @@access_counter += 1
  end

  def reset_counter
    @@last_access = Time.now
    @@access_counter = 0
  end

  def too_many_api_hits?
    @@access_counter >= 60 && Time.now - @@last_access <= 60
  end

  def remaining_seconds
    [60 - (Time.now - @@last_access), 0].max
  end

  def hit_count
    @@access_counter
  end

  def throttle_to_the_minute!
    tick_api_counter!
    if too_many_api_hits?
      puts "The GitHub API does not allow more than 60 requests per minute. Sleeping for #{remaining_seconds} seconds."
      sleep( remaining_seconds )
    end
  end

  def request(method, path)
    throttle_to_the_minute!
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

  def postreceive(hooks)
    throttle_to_the_minute!
    url = URI.parse "https://github.com/#{@account}/#{@project}/edit/postreceive_urls"

    req = Net::HTTP::Post.new(url.path)
    req.body = "login=#{@account}&token=#{@api_key}&#{hooks.map { |hook| "urls[]=#{hook}" }.join('&')}"
    req.content_type = 'application/x-www-form-urlencoded'

    server = Net::HTTP.new url.host, url.port
    server.use_ssl = url.scheme == 'https'
    server.verify_mode = OpenSSL::SSL::VERIFY_NONE

    res = server.start {|http| http.request(req) }
    res.body
  end
end
