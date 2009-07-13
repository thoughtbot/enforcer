#!/usr/bin/env ruby

require 'rubygems'
require 'lib/enforcer'

token = `git config github.token`

Enforcer "qrush", token do
  project "jekyll" do
    collaborators "coreyhaines"
  end
end
