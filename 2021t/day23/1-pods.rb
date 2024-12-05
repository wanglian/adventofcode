file = File.open 'input.txt'

data = [
  '#############',
  '#...........#',
  '###B#C#B#D###',
  '  #A#D#C#A#',
  '  #########',
]

data = file.readlines.map(&:chomp)

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

def init_grid(data)
  grid = [Array.new(11)]
  HOME.values.each do |x|
    [2, 3].each do |y|
      grid[y-1] ||= []
      grid[y-1][x] = data[y][x+1]
    end
  end
  grid
end

def finished?(grid)
  [1, 2].each do |y|
    HOME.each do |char, x|
      return false unless char == grid[y][x]
    end
  end
  true
end

def ready?(grid, x, y)
  return false if !HOME.values.include?(x) || y == 0

  case x
  when 2
    grid[y][x] == 'A' && (y == 2 || (y == 1 && grid[2][x] == 'A'))
  when 4
    grid[y][x] == 'B' && (y == 2 || (y == 1 && grid[2][x] == 'B'))
  when 6
    grid[y][x] == 'C' && (y == 2 || (y == 1 && grid[2][x] == 'C'))
  when 8
    grid[y][x] == 'D' && (y == 2 || (y == 1 && grid[2][x] == 'D'))
  end
end

def can_move?(grid, x, y)
  char = grid[y][x]
  return false unless char
  
  if HOME.values.include?(x)
    ready = ready?(grid, x, y)
    !ready && (!grid[0][HOME[char]-1] || !grid[0][HOME[char]+1])
  else
    !grid[0][HOME[char]-1] || !grid[0][HOME[char]+1]
  end
end

def movable_pods(grid)
  pods = []
  (0..10).each do |i|
    char = grid[0][i]
    next unless char
    
    k = HOME[char]
    next if grid[1][k] && grid[1][k] != char
    next if grid[2][k] && grid[2][k] != char
    if i < k
      min, max = i + 1, k
    else
      min, max = k, i - 1
    end
    pods << [i, 0] if grid[0][min..max].compact.empty? && can_move?(grid, i, 0)
  end
  y = 1
  HOME.values.each do |x|
    char = grid[y][x]
    if char && (HOME[char] != x || !ready?(grid, x, y+1))
      pods << [x, y] if can_move?(grid, x, y)
    end
  end
  y = 2
  HOME.values.each do |x|
    char = grid[y][x]
    if char && !grid[y-1][x] && HOME[char] != x && !ready?(grid, x, y)
      pods << [x, y] if can_move?(grid, x, y)
    end
  end
  # p pods
  pods
end

def move_options(grid, pos)
  # pp grid
  # p pos
  x, y = pos[0], pos[1]
  char = grid[y][x]
  raise 'no pod' unless char
  
  re = []
  k = HOME[char]
  if k == x || (grid[1][k] && grid[1][k] != char) || (grid[2][k] && grid[2][k] != char)
    # no
  else
    if x < k
      min, max = x + 1, k
    else
      min, max = k, x - 1
    end
    if grid[0][min..max].compact.empty?
      if ready?(grid, k, 2)
        re << [k, 1]
      else
        re << [k, 2]
      end
      return re
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

grid = init_grid data
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
  (0..2).each do |y|
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

p move(grid)
# p move(grid, [6, 1], [3, 0])

# grid = [
#   "B..B.D.....",
#   "......C..",
#   "..A.D.C.A",
# ].map {|r| r.split('').map{|d| d == '.' ? nil : d}}
#
# pp grid
#
# p movable_pods(grid)
# p move_options(grid, [8, 2])

t2 = Time.now
p t2
p (t2-t1)
