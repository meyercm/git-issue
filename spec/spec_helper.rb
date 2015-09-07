if RUBY_VERSION !~ /^1\.8/ then
  require 'coveralls'
  Coveralls.wear!
end
ENV['GIT_ISSUE_TEST'] = 'true'
load File.expand_path("../target.rb", __FILE__)

warn `git --version`
# def rig &block

# end