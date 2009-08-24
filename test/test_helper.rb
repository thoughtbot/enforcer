require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rr'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'enforcer'

begin
  require 'redgreen'
rescue LoadError
end

class Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def setup
    RR.reset
    stub(STDOUT).puts
  end

  def teardown
    begin
      RR.verify
    ensure
      RR.reset
    end
  end
end
