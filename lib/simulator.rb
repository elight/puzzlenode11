class Simulator
  attr_reader :cave

  def initialize(cave, last_flow_coord = [1,0])
    @cave = cave
    @last_flow_coord = last_flow_coord
  end

  def flow
    self
  end

  def to_s
    @cave
  end
end
