data = File.open('input/day14.txt').readlines.map(&:chomp)
  .map { |row| row.split(' -> ').map { |point| point.split(',').map(&:to_i) } }

# p data
@y_max = data.map { |row| row.map { |p| p[1]}.max }.max
@min = data.map { |row| row.map { |p| p[0]}.min }.min - @y_max - 3
@max = data.map { |row| row.map { |p| p[0]}.max }.max + @y_max + 3

def fill(grid, p1, p2)
  if p1[0] == p2[0]
    min, max = [p1[1], p2[1]].sort
    (min..max).each do |i|
      grid[i] ||= []
      grid[i][p1[0] - @min] = '#'
    end
  else
    grid[p1[1]] ||= []
    min, max = [p1[0], p2[0]].sort
    (min..max).each do |j|
      grid[p1[1]][j - @min] = '#'
    end
  end
end

def init(data, y_max, endless = true)
  grid = []
  (y_max + 1).times.with_index do |i|
    grid[i] = Array.new @max - @min, '.'
  end
  unless endless
    grid[y_max] = Array.new @max - @min, '#'
  end
  data.each do |row|
    i = 0
    while i < row.length - 1
      fill(grid, row[i], row[i+1])
      i += 1
    end
  end
  grid
end

def move(grid, pos = nil)
  pos ||= [500 - @min, 0]
  x = pos[0]
  y = pos[1]
  if y >= (grid.length - 1)
    return false
  elsif grid[y+1][x] == '.'
    return move(grid, [x, y+1])
  elsif x > 0 && grid[y+1][x-1] == '.'
    return move(grid, [x-1, y+1])
  elsif x < (grid[y].length - 1) && grid[y+1][x+1] == '.'
    return move(grid, [x+1, y+1])
  elsif x > 0 && x < (grid[y].length - 1)
    grid[y][x] = 'o'
    return false if y == 0
    return grid
  else
    return false
  end
end

def p1(grid)
  while true
    break unless move(grid)
  end
  grid.map { |row| row ? row.count('o') : 0 }.sum
end

grid = init(data, @y_max)
p p1(grid)
# grid.each { |r| p r.join }f
@y_max += 2
grid = init(data, @y_max, false)
p p1(grid)
