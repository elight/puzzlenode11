class Simulator
  def initialize(cave, flow_stack = [[1, 0]])
    @cave = cave
    @flow_stack = flow_stack
  end

  def flow!
    row, col = FlowRules.new(@cave, @flow_stack).next_cell
    @flow_stack.push([row, col])
    @cave = fill_coord_in_cave(row, col, @cave)
  end

  def to_s
    @cave
  end

  def fill_coord_in_cave(row, col, cave)
    Grid.from(cave).fill(row, col).to_s
  end

  def depth_counts
    grid = Grid.from(@cave)
    (0...grid.width).map { |col|
      grid.depth_for_col(col)
    }
  end
end

class FlowRules
  def initialize(cave, flow_stack)
    @cave = cave
    @flow_stack = flow_stack
  end

  def next_cell
    flow = @flow_stack.dup
    last_coord = flow.pop
    row, col = last_coord[0], last_coord[1]

    if cell_below_is_open?
      row += 1
    elsif cell_right_is_open?
      col += 1
    else
      row, col = FlowRules.new(@cave, flow).next_cell
    end
    [row, col]
  end

  def cell_below_is_open?
    grid = Grid.from(@cave)
    grid.at(@flow_stack.last[0] + 1, @flow_stack.last[1]) == ' '
  end

  def cell_right_is_open?
    grid = Grid.from(@cave)
    grid.at(@flow_stack.last[0], @flow_stack.last[1] + 1) == ' '
  end
end

class Grid
  def self.from(cave)
    new(cave)
  end

  def initialize(cave)
    @rows = cave.split(/\n/).map(&:strip)
  end

  def at(row, col)
    @rows[row][col]
  end
  
  def water_at?(row, col)
    at(row, col) == '~'
  end

  def fill(row, col)
    @rows[row][col] = '~'
    self
  end

  def to_s
    @rows.join("\n") + "\n"
  end

  def width
    @rows.first.size
  end

  def height
    @rows.size - 1
  end

  def depth_for_col(col)
    water_found = false
    (1..height - 1).inject(0) { |m, row|
      v = @rows[row][col]
      if v == '~'
        water_found = true
        m += 1
      elsif water_found && v == ' '
        m = '~'
      end
      m
    }
  end
end

