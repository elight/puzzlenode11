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

describe "FlowRules" do
  describe "for a cave where the next available space is right" do
    let(:cave) {
      <<-HERE
      ####
      ~~ #
      ####
      HERE
    }

    it "identifies the coord of the next right cell to fill with water" do
      assert_equal([1,2], FlowRules.new(cave, [1,1]).next_cell)
    end
  end

  describe "for a cave where the next available space is down" do
    let(:cave) {
      <<-HERE
      ###
      ~~#
      # #
      ###
      HERE
    }

    it "identifies the coord of the next cell to fill with water" do
      assert_equal([2,1], FlowRules.new(cave, [1,1]).next_cell)
    end
  end
end
