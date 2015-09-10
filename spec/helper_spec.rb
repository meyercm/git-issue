require 'spec_helper'

describe "Helper" do
  describe "#first_non_blank" do
    before do
      @first = Object.new
    end
    it "works with nil up front" do
      ary = [nil, nil, @first, nil, "blah"]
      expect(GitIssue::Helper.first_non_blank ary).to eq(@first)
      ary = [nil, @first, nil, "blah"]
      expect(GitIssue::Helper.first_non_blank ary).to eq(@first)
      ary = [nil, @first]
      expect(GitIssue::Helper.first_non_blank ary).to eq(@first)
    end
    it "works with blanks up front" do
      ary = ["",@first, nil, "blah"]
      expect(GitIssue::Helper.first_non_blank ary).to eq(@first)
      ary = ["","",@first, nil, "blah"]
      expect(GitIssue::Helper.first_non_blank ary).to eq(@first)
      ary = ["",@first, nil]
      expect(GitIssue::Helper.first_non_blank ary).to eq(@first)
    end
    it "works with both up front" do
      ary = ["", nil, @first, nil, "blah"]
      expect(GitIssue::Helper.first_non_blank ary).to eq(@first)
      ary = [nil,"",@first]
      expect(GitIssue::Helper.first_non_blank ary).to eq(@first)
    end
    it "works with neither up front" do
      ary = [@first, nil, "blah"]
      expect(GitIssue::Helper.first_non_blank ary).to eq(@first)
      ary = [@first]
      expect(GitIssue::Helper.first_non_blank ary).to eq(@first)
    end
    it "returns nil for empty ary" do
      ary = []
      expect(GitIssue::Helper.first_non_blank ary).to eq(nil)
    end
  end
  describe "#is_partial_sha?" do
    it "returns true for one character" do
      ["A".."F","a".."f", "0".."9"].map{|i| i.to_a}.flatten.each do |l|
        expect(GitIssue::Helper.is_partial_sha? l).to eq(true)
      end
    end
    it "works for some legit examples" do
      [
        "049c8389f979077ae31f13b2416bb23ff088d774",
        "17c6ff72",
        "27",
        "282cfa20b374140d93477dc465b498c630e44065",
        "2cfa1bbfefbb9e8c3f45e444ac732491fcb587e1",
        "2d52eb1e072e318dd765d8b9df55857b7159c087",
        "3273070c83d66260e59bd294107f931b3728d126",
        "33dc7b01c027a8eefe960c6b234c3ff794eb7e59",
        "3a2a3c124c7107c61cf91417ba68b45b214c7e36",
      ].each do |l|
        expect(GitIssue::Helper.is_partial_sha? l).to eq(true)
      end
    end

    it "fails for too long" do
      l = "3a2a3c124c7107c61cf91417ba68b45b214c7e36a" #extra char.
      expect(GitIssue::Helper.is_partial_sha? l).to eq(false)
    end
    it "fails for blank" do
      expect(GitIssue::Helper.is_partial_sha? "").to eq(false)
    end
    it "fails for non-hex" do
      expect(GitIssue::Helper.is_partial_sha? "hey dude").to eq(false)
    end

  end

  describe "#tags_match" do

  end

end