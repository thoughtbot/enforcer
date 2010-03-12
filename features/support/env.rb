require 'fileutils'
require 'rr'
require 'test/unit'
require 'lib/enforcer'
require 'fakeweb'

FakeWeb.allow_net_connect = false

TEST_DIR    = File.join('/', 'tmp', 'enforcer')

World(Test::Unit::Assertions)
World(RR::Adapters::TestUnit)

Before do
  RR.reset
  stub(STDOUT).puts
end

After do
  begin
    RR.verify
  ensure
    RR.reset
  end
end

