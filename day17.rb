require './utils.rb'

data = get_input("17")

@grid = []

def init_rock(type)
  case type
  when 0
    [
      [0, 0],
      [1, 0],
      [2, 0],
      [3, 0]
    ]
  when 1
    [
      [1, 0],
      [0, 1],
      [1, 1],
      [2, 1],
      [1, 2]
    ]
  when 2
    [
      [0, 0],
      [1, 0],
      [2, 0],
      [2, 1],
      [2, 2]
    ]
  when 3
    [
      [0, 0],
      [0, 1],
      [0, 2],
      [0, 3]
    ]
  when 4
    [
      [0, 0],
      [1, 0],
      [0, 1],
      [1, 1]
    ]
  else
    raise "error type: #{type}"
  end
end

@patterns = data.first
def get_direction(step)
  @patterns[step % @patterns.size]
end

def can_move?(rock, pos, direction)
  bx, by = pos
  if direction == '<'
    rock.each do |point|
      x, y = point
      return false if (bx + x) == 0
      return false if @grid[by + y] && @grid[by + y][bx + x - 1]
    end
  elsif direction == '>'
    rock.each do |point|
      x, y = point
      return false if (bx + x) == 6
      return false if @grid[by + y] && @grid[by + y][bx + x + 1]
    end
  else
    raise "error direction: #{direction}"
  end
  true
end

def can_down?(rock, pos)
  bx, by = pos
  return false if by == 0

  rock.each do |point|
    x, y = point
    return false if @grid[by + y - 1] && @grid[by + y - 1][bx + x]
  end
  true
end

def merge(rock, pos)
  bx, by = pos
  rock.each do |point|
    x, y = point
    @grid[by + y] ||= []
    @grid[by + y][bx + x] = '#'
  end
end

def check
  x = 0
  min = @grid.size - 1
  while x < 7
    y = @grid.size - 1
    while y > 0
      if @grid[y][x]
        min = y if y < min
        break
      end
      y -= 1
    end
    x += 1
  end
  min
end

def truncate()
  
end

def p1(max)
  result = 0
  @grid = []
  base = 0
  count = 0
  step = 0

  while count < max
    rock = init_rock(count % 5)
    y = base + 3
    x = 2

    while true
      direction = get_direction(step)
      if can_move?(rock, [x, y], direction)
        x = direction == '<' ? x - 1 : x + 1
      end
      step += 1
      break unless can_down?(rock, [x, y])
      y -= 1
    end
    merge(rock, [x, y])
    
    if @grid.size > 100
      n = check
      if n > 0
        @grid.shift(n)
        result += n
      end
    end
    # @grid.map {|r| r.map {|e| e || '.'}}.reverse.each {|r| p r.join}

    count += 1
    base = @grid.size
  end

  result + @grid.size
end

# part 1
with_time { p p1(2022) }
# part 2
# with_time { p p1(1000000000000) }
