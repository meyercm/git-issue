if RUBY_VERSION !~ /^1\.8/ then
  require 'coveralls'
  Coveralls.wear!
end
ENV['GIT_ISSUE_TEST'] = 'true'
load File.expand_path("../target.rb", __FILE__)


#travis has git 1.8.5.6 as of 7Sep2015