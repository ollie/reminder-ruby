#!/usr/bin/env ruby

require 'bundler'
Bundler.require

require File.expand_path('../app/boot', __FILE__)

app = App.new
app.run
