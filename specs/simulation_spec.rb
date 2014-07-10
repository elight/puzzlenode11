require_relative 'spec_helper'

describe Simulator do
  it "can stringify its state" do
    initial = <<-HERE.gsub(/^ {6}/, '')
      ####
      ~~ #
      #  #
      ####
    HERE

    assert_equal initial, Simulator.new(initial).to_s
  end

  describe "water" do
    it "flows down before it flows right" do
      initial = <<-HERE.gsub(/^ {8}/, '')
        ####
        ~~ #
        #  #
        ####
      HERE

      expected = <<-HERE
        ####
        ~~ #
        #~ #
        ####
      HERE

      assert_equal expected, Simulator.new(initial).flow.to_s
    end
  end
end
