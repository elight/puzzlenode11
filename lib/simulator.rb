class Simulator
  def initialize(cave, last_flow_coord = [1,0])
    @cave = cave
    @last_flow_coord = last_flow_coord
  end

  def flow
    coord = FlowRules.new(@cave, @last_flow_coord).next_cell
    Simulator.new(fill_coord_in_cave(coord, @cave))
  end

  def to_s
    @cave
  end

  def fill_coord_in_cave(coord, cave)
    @cave
  end
end

class FlowRules
  def initialize(cave, last_flow_coord = [1, 0])
    @cave = cave
    @last_flow_coord = last_flow_coord
  end

  def next_cell
    @last_flow_coord.dup.tap { |new_coord|
      if cell_below_is_open?
        new_coord[0] += 1
      elsif cell_right_is_open?
        new_coord[1] += 1
      else
        # flow back up 1 and check again
      end
    }
  end

  def cell_below_is_open?
    grid = Grid.from(@cave)
    grid.at(@last_flow_coord[0], @last_flow_coord[1] + 1) == ' '
  end

  def cell_right_is_open?
    grid = Grid.from(@cave)
    grid.at(@last_flow_coord[0] + 1, @last_flow_coord[1]) == ' '
  end
end

class Grid
  def self.from(cave)
    new(cave)
  end

  def initialize(cave)
    @rows = cave.split(/\n/).map(&:strip)
  end

  def at(x, y)
    @rows[y][x]
  end
end

