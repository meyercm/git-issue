require 'spec_helper'
describe GitIssue::BaseCommand do
  describe "#clean_message!" do
    it "raises an IssueError on empty message" do
      expect{subject.clean_message!("")}.to raise_error GitIssue::IssueError
    end
    it "raises an IssueError on only comment message" do
      expect{subject.clean_message!('#$# Comment')}.to raise_error GitIssue::IssueError
      expect{
        subject.clean_message!(' #$# Comment')
      }.to raise_error GitIssue::IssueError
    end
    it "raises an IssueError on a realistic message" do
      expect{subject.clean_message!('


#$# Comment1
#$# Comment2
'
          )}.to raise_error GitIssue::IssueError
    end

    it "returns the title as the title" do
      expect(subject.clean_message!("hey you")).to eq(["hey you", ""])
    end
    it "returns the body as the body" do
      expect(subject.clean_message!("hey you
blahblah")).to eq(["hey you", "blahblah"])
    end
    it "strips comments" do
      expect(subject.clean_message!('hey you
blahblah
#$# comment')).to eq(["hey you", "blahblah"])
    end
    it "strips trailing whitespace" do
      expect(subject.clean_message!("hey you
blahblah   ")).to eq(["hey you", "blahblah"])
    end
  end

  describe "#validate_sha" do
    it "returns the sha for potential shas" do
      expect(subject.validate_sha("deadbeef")).to eq("deadbeef")
    end
    it "raises issue error for garbage" do
      expect{subject.validate_sha("hey you guys!")}.to raise_error GitIssue::IssueError
    end
  end
end