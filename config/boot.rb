require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler'
Bundler.require

require File.expand_path('../../lib/core_ext', __FILE__)
