require 'fileutils'
require 'rr'
require 'test/unit'
require 'enforcer'

World(Test::Unit::Assertions)
World(RR::Adapters::TestUnit)
