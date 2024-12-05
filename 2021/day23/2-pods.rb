require 'pry'

file = File.open 'input.txt'

data = [
  '#############',
  '#...........#',
  '###B#C#B#D###',
  '  #D#C#B#A#',
  '  #D#B#A#C#',
  '  #A#D#C#A#',
  '  #########',
]

# data = file.readlines.map(&:chomp)

data = [
  '#############',
  '#...........#',
  '###D#C#D#B###',
  '  #D#C#B#A#',
  '  #D#B#A#C#',
  '  #C#A#A#B#',
  '  #########',
]

HOME = {
  'A' => 2,
  'B' => 4,
  'C' => 6,
  'D' => 8,
}

ENERGY = {
  'A' => 1,
  'B' => 10,
  'C' => 100,
  'D' => 1000,
}

@trace = []

def init_grid(data)
  grid = [Array.new(11)]
  HOME.values.each do |x|
    [2, 3, 4, 5].each do |y|
      grid[y-1] ||= []
      grid[y-1][x] = data[y][x+1]
    end
  end
  grid
end

def finished?(grid)
  [1, 2, 3, 4].each do |y|
    HOME.each do |char, x|
      return false unless char == grid[y][x]
    end
  end
  true
end

def movable_pods(grid)
  pods = []
  (0..10).each do |i|
    char = grid[0][i]
    next unless char
    
    k = HOME[char]
    next if grid[1][k] && grid[1][k] != char
    next if grid[2][k] && grid[2][k] != char
    next if grid[3][k] && grid[3][k] != char
    next if grid[4][k] && grid[4][k] != char
    if i < k
      min, max = i + 1, k
    else
      min, max = k, i - 1
    end
    pods << [i, 0] if grid[0][min..max].compact.empty?
  end
  y = 1
  HOME.values.each do |x|
    [1, 2, 3, 4].each do |y|
      char = grid[y][x]
      next unless char
      if HOME[char] == x
        if y < 4
          b = false
          ((y+1)..4).each do |yy|
            unless grid[yy][x] == char
              b = true
              break
            end
          end
          if b
            pods << [x, y]
            break
          end
        end
      else
        pods << [x, y]
        break
      end
    end
  end
  # p pods
  pods
end

def room_has_other?(grid, x)
  # binding.pry
  (1..4).each do |y|
    return true if grid[y][x] && HOME[grid[y][x]] != x
  end
  false
end

def room_first_available_pos(grid, x)
  return false if room_has_other?(grid, x)
  (1..4).each do |y|
    if grid[y][x]
      return y > 1 ? y-1 : false
    end
  end
  4
end

def move_options(grid, pos)
  # pp grid
  # p pos
  x, y = pos[0], pos[1]
  char = grid[y][x]
  raise 'no pod' unless char
  
  re = []
  k = HOME[char]
  if k == x || room_has_other?(grid, k)
    # no
  else
    @trace[10] ||= 0
    if x < k
      min, max = x + 1, k
    else
      min, max = k, x - 1
    end
    if grid[0][min..max].compact.empty?
      ay = room_first_available_pos grid, k
      re << [k, ay] if ay
      return re unless re.empty?
    end
  end
  
  if y > 0
    k = 1
    left, right = true, true
    while left || right
      if left && (x-k) >=0 && !grid[0][x-k]
        re << [x-k, 0] unless HOME.values.include?(x-k)
      else
        left = false
      end
      if right && (x+k) < grid[0].size && !grid[0][x+k]
        re << [x+k, 0] unless HOME.values.include?(x+k)
      else
        right = false
      end
      k += 1
    end
  end
  # re = re.sort {|a, b| a[0] <=> b[0]}
  # p re
  re
end

# p grid
# p finished?(grid)
# p can_move?(grid, 2, 1)
# p movable_pods(grid)

def deep_clone(array)
  n = []
  array.each {|a| n << a.clone}
  n
end

def pp(grid)
  (0..4).each do |y|
    p grid[y].map{|p| p || '.'}.join
  end
  size = grid.inject(0){|sum, r| sum + r.compact.size}
  raise if size < 8
end

def move(g, pod=nil, pos=nil)
  grid = deep_clone g
  cost = 0
  if pod && pos
    x1, y1 = pod[0], pod[1]
    x2, y2 = pos[0], pos[1]
    char = grid[y1][x1]
    grid[y2][x2] = char
    grid[y1][x1] = nil
    steps = (x1-x2).abs
    if y1 == 0 || y2 == 0
      steps += (y1-y2).abs
    else
      steps += y1 + y2
    end
    cost = ENERGY[char] * steps
    # p "===> move #{pod} #{pos}: #{cost}"
  end
  if finished?(grid)
    # p "======================================================="
    # pp grid
    return cost
  end

  ms = movable_pods(grid)
  return false if ms.empty?
  min = nil
  ms.each do |po|
    re = nil
    options = move_options(grid, po)
    next if options.empty?
    options.each do |ps|
      r = move grid, po, ps
      re = r if r && (re.nil? || r < re)
      # break if re
    end
    min = re if re && (min.nil? || re < min)
    # break if min
  end
  return false if min.nil?
  cost + min
end

t1 = Time.new
p t1

grid = init_grid data
p move(grid)

# p move(grid, [8, 1], [10, 0])

# grid = [
#   "BD.......DD",
#   "....C.B..",
#   "....C.B.A",
#   "....B.A.C",
#   "..A.D.C.A",
# ].map {|r| r.split('').map{|d| d == '.' ? nil : d}}
#
# pp grid
#
# p movable_pods(grid)
# p move_options(grid, [8, 2])

p @trace

t2 = Time.now
p t2
p (t2-t1)
