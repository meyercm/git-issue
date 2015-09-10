require 'spec_helper'

describe "GitWorker" do
  describe "#hash_str" do
    it "can hash a string with a single quote" do
      GitIssue::GitWorker.hash_str("a'b")
    end
    it "can hash a string with a double quote" do
      GitIssue::GitWorker.hash_str('a"b')
    end
    it "can hash a string with a semicolon" do
      GitIssue::GitWorker.hash_str("a;b")
    end
  end
end