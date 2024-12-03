require './utils.rb'

data = get_input("24").map { |row| row.split('') }
# p data

def mark(data, shares={}, pos, b)
  x, y = pos
  x = 1 if x == data.first.size - 1
  y = 1 if y == data.size - 1
  x = data.first.size - 2 if x == 0
  y = data.size - 2 if y == 0

  v = data[y][x]
  if v == '.'
    data[y][x] = b
  else
    k = "#{x}-#{y}"
    shares[k] ||= [v]
    shares[k] << b
    data[y][x] = shares[k].size
  end
end

def next_pos(pos, c)
  x, y = pos
  case c
  when '>'
    [x+1, y]
  when '<'
    [x-1, y]
  when 'v'
    [x, y+1]
  when '^'
    [x, y-1]
  end
end

def next_map(data, shares={})
  # data.each {|r| p r.join}
  new_map = Array.new(data.size) { Array.new(data.first.size, '.') }
  new_shares = {}
  data.each.with_index do |r, y|
    next if y == 0 || y == (data.size - 1)
    r.each.with_index do |c, x|
      next if x == 0 || x == (data.first.size - 1)
      if c.is_a?(Integer)
        shares["#{x}-#{y}"].each do |sc|
          mark(new_map, new_shares, next_pos([x, y], sc), sc)
        end
      end
      if ['>', '<', 'v', '^'].include?(c)
        mark(new_map, new_shares, next_pos([x, y], c), c)
      end
    end
  end
  [new_map, new_shares]
end

def available(data, pos)
  x, y = pos
  re = []
  re << [x+1, y] if x < (data.first.size - 2) && y > 0
  re << [x, y+1] if y < (data.size - 2)
  re << [x-1, y] if x > 1 && y > 0 && y < (data.size - 1)
  re << [x, y-1] if y > 1
  re << [x, y]
  re.select { |pos| data[pos[1]][pos[0]] == '.' }
end

# BFS
def p1(data, shares, p_start, p_end, step=1)
  points = [p_start]
  while true
    # p "step #{step}"
    data, shares = next_map(data, shares)
    # p points
    # data.each {|r| p r.join}
    points = points.inject([]) do |sum, pos|
      sum + available(data, pos)
    end.uniq
    if points.include?(p_end)
      data, shares = next_map(data, shares)
      step += 1
      break
    end
    step += 1
  end
  [data, shares, step]
end

def p2(data, shares, p_start, p_end, c_start, c_end)
  data, shares, r1 = p1(data, shares, p_start, c_end)
  data, shares, r2 = p1(data, shares, p_end, c_start)
  data, shares, r3 = p1(data, shares, p_start, c_end)
  p [r1, r2, r3]
  r1 + r2 + r3
end

p_start = [1, 0]
c_start = [1, 1]
p_end = [data.first.size - 2, data.size - 1]
c_end = [data.first.size - 2, data.size - 2]
shares = {}
# part 1
# with_time do
#   data, shares, s1 = p1(data, shares, p_start, c_end)
#   p "part 1: #{s1}"
# end

# part 2
with_time do
  p p2(data, shares, p_start, p_end, c_start, c_end)
end
