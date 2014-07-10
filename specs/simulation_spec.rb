require_relative 'spec_helper'

describe "acceptance test" do
  let(:input) {
    <<-HERE
      ################################
      ~                              #
      #         ####                 #
      ###       ####                ##
      ###       ####              ####
      #######   #######         ######
      #######   ###########     ######
      ################################
    HERE
  }

  let(:expected) {
    <<-HERE
################################
~~~~~~~~~~~~~~~                #
#~~~~~~~~~####~~~~~~~~~~~~     #
###~~~~~~~####~~~~~~~~~~~~~~~~##
###~~~~~~~####~~~~~~~~~~~~~~####
#######~~~#######~~~~~~~~~######
#######~~~###########~~~~~######
################################
HERE
  }

  let(:sim) { 
    Simulator.new(input).tap { |s|
      # 99 because the initial unit counts as well
      99.times do
        s.flow!
      end
    }
  }   

  let(:expected_counts) {
    "1 2 2 4 4 4 4 6 6 6 1 1 1 1 4 3 3 4 4 4 4 5 5 5 5 5 2 2 1 1 0 0".split.map(&:to_i)
  }

  it "should match the supplied sample" do
    assert_equal(expected, sim.to_s)
  end

  it "should count the depth out correctly for each column" do
    assert_equal(expected_counts, sim.depth_counts)
  end
end

describe Simulator do
  it "can stringify its state" do
    initial = <<-HERE
      ####
      ~~ #
      #  #
      ####
    HERE

    assert_equal initial, Simulator.new(initial).to_s
  end

  describe "water" do
    it "flows down before it flows right" do
      initial = <<-HERE
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

      assert_equal expected, Simulator.new(initial, [[1, 0], [1, 1]]).flow!.to_s
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
      assert_equal([1,2], FlowRules.new(cave, [[1, 0], [1, 1]]).next_cell)
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
      assert_equal([2,1], FlowRules.new(cave, [[1, 0], [1, 1]]).next_cell)
    end
  end

  describe "for a cave where there is space right and down" do
    let(:cave) {
      <<-HERE
      ####
      ~~ #
      #  #
      ####
      HERE
    }

    it "selects the down coord" do
      assert_equal([2,1], FlowRules.new(cave, [[1, 0], [1, 1]]).next_cell)
    end
  end

  describe "starting to fill the second level of water in a cave" do
    let(:cave) {
      <<-HERE
      #####
      ~~  #
      #~  #
      #~~~#
      #####
      HERE
    }

    it "fills the next available right cell above the filled level" do
      assert_equal([2,2], FlowRules.new(cave, [[2, 1], [3, 1], [3, 2], [3, 3]]).next_cell)
    end
  end

  describe "filling the second level of water in a cave" do
    let(:cave) {
      <<-HERE
      #####
      ~~  #
      #~~ #
      #~~~#
      #####
      HERE
    }

    it "fills the next available right cell above the filled level" do
      assert_equal([2,3], FlowRules.new(cave, [[3, 3], [2, 2]]).next_cell)
    end
  end

  describe "flowing over obstacles" do
    let(:cave) {
      <<-HERE
      #####
      ~~  #
      #~# #
      #####
      HERE
    }

    it "fills in above obstacles" do
      assert_equal([1,2], FlowRules.new(cave, [[1, 0], [1, 1], [2, 1]]).next_cell)
    end
  end

  describe "filling over obstacles" do
    let(:cave) {
      <<-HERE
      #####
      ~~~ #
      #~# #
      #####
      HERE
    }

    it "fills in above obstacles" do
      assert_equal([1,3], FlowRules.new(cave, [[1, 0], [1, 1], [2, 1], [1, 2]]).next_cell)
    end
  end
end
