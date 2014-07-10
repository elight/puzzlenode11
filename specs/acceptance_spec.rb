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

describe "depth counts edge case" do
  let(:actual) {
    input = <<-HERE
################################
~~~~~~~~~~~~~~~                #
#~~~~~~~~~####~                #
###~~~~~~~####                ##
###~~~~~~~####              ####
#######~~~#######         ######
#######~~~###########     ######
################################
HERE
    Simulator.new(input).depth_counts.map(&:to_s)
  }

  let(:expected) {
    "1 2 2 4 4 4 4 6 6 6 1 1 1 1 ~ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0".split
  }

  it "should count flowing water correctly" do
    assert_equal(expected, actual)
  end
end
