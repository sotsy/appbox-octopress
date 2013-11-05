require 'fileutils'
require File.join(File.dirname(__FILE__) + '/appbox_octopress/utilities')

if ARGV.length == 1 && ARGV[0] == 'install'
  AppboxOctopress::Utilities.install
  puts "Appbox Octopress installed"
elsif ARGV.length == 1 && ARGV[0] == 'remove'
  AppboxOctopress::Utilities.remove
  puts "Appbox Octopress removed"
else
  puts "Usage: appbox-octopress [install|remove]"
end