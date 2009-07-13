require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'enforcer'
require 'rr'

begin
  require 'redgreen'
rescue LoadError
end

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end
