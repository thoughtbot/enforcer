#!/usr/bin/env ruby

require 'lib/enforcer'

token = `git config github.token`

Enforcer "qrush", token.chomp do
  project "aquinas", "qrush", "mittens"
end
