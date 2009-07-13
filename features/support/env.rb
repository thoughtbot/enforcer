require 'fileutils'
require 'rr'
require 'test/unit'
require 'enforcer'
require 'fakeweb'

FakeWeb.allow_net_connect = false

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

