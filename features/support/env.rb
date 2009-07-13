require 'fileutils'
require 'rr'
require 'test/unit'
require 'enforcer'
require 'fakeweb'

FakeWeb.allow_net_connect = false

World(Test::Unit::Assertions)
World(RR::Adapters::TestUnit)
