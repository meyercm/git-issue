require 'spec_helper'

describe GitIssue::NewCommand do
  before do
    allow(subject).to receive(:write_output).and_return(nil)
  end
  describe '#parse' do
  end
  describe '#run' do
    before do
      @options = OpenStruct.new
    end
    it "creates an issue with a simple message" do
      @options.message = 'hi'
      expect(GitIssue::Issue).to receive(:create_new).with("hi", "", nil).and_return(OpenStruct.new({:short_id => "12345678"}))
      subject.run(@options)
    end
    it "creates an issue with a complex message" do
      @options.message = 'hi
bub'
      expect(GitIssue::Issue).to receive(:create_new).with("hi", "bub", nil).and_return(OpenStruct.new({:short_id => "12345678"}))
      subject.run(@options)
    end
    it "creates an issue with tags" do
      @options.message = 'hi'
      tags = Object.new
      @options.tags = tags
      expect(GitIssue::Issue).to receive(:create_new).with("hi", "", tags).and_return(OpenStruct.new({:short_id => "12345678"}))
      subject.run(@options)
    end
    it "gets a message from the editor if there isn't one in the options" do
      expect(subject).to receive(:get_message_from_editor).and_return(["test_title", "test_desc"])
      expect(GitIssue::Issue).to receive(:create_new).with("test_title", "test_desc", nil).and_return(OpenStruct.new({:short_id => "12345678"}))
      subject.run(@options)
    end
  end
end