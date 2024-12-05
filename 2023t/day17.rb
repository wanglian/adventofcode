require './utils.rb'

data = get_input("17").map {|row| row.split('').map(&:to_i)}


def p1(data)
  min_heap = [[0, [0, 0], 0]]
  visited = {}
  while min_heap.size > 0
    level, pos, steps = min_heap.pop
    visited[pos] = true
    x, y = pos
    nodes = []
    nodes << [x-1, y] if x > 0
    nodes << [x+1, y] if x < (data.size-1)
    nodes << [x, y-1] if y > 0
    nodes << [x, y+1] if y < (data[0].size-1)
    nodes.select do |pn|
      visited[pn].nil?
    end.each do |pn|
      px, py = pn
      min_heap << [level + data[px][py], pn, ]
    end
  end
end

def bfs(graph)
  paths = [[0, 0]]
  result = nil
  while paths.size > 0
    tmp = []
    # paths.each { |path| p path}
    # binding.break
    paths.each do |path|
      # p path
      pos = path.last
      x, y = pos
      if x == (data.size-1) && y == (data[0].size-1)
      nodes = graph[path.last][1]
      nodes.each do |node|
        x, y = node
        npv = pv + data[x][y]
        if x == (data.size-1) && y == (data[0].size-1)
          p "#{path} - #{npv}"
          if result.nil? || result > npv
            result = npv
          end
        elsif result.nil? || result > npv
          tp = path.clone
          tp << node
          tmp << tp
        end
      end
    end
    paths = tmp
  end
  result
end

def next_nodes(data, path)
  nodes = []
  x, y = path.last
  case direction(path)
  when 'right'
    nodes << [x, y+1] if y < (data[0].size-1) && can_forward(path) && !path.include?([x, y+1])
    nodes << [x+1, y] if x < (data.size-1) && !path.include?([x+1, y])
    nodes << [x-1, y] if x > 0 && !path.include?([x-1, y])
  when 'left'
    nodes << [x, y-1] if y > 0 && can_forward(path) && !path.include?([x, y-1])
    nodes << [x+1, y] if x < (data.size-1) && !path.include?([x+1, y])
    nodes << [x-1, y] if x >0 && !path.include?([x-1, y])
  when 'up'
    nodes << [x-1, y] if x > 0 && can_forward(path) && !path.include?([x-1, y])
    nodes << [x, y+1] if y < (data[0].size-1) && !path.include?([x, y+1])
    nodes << [x, y-1] if y > 0 && !path.include?([x, y-1])
  when 'down'
    nodes << [x+1, y] if x < (data.size-1) && can_forward(path) && !path.include?([x+1, y])
    nodes << [x, y+1] if y < (data[0].size-1) && !path.include?([x, y+1])
    nodes << [x, y-1] if y > 0 && !path.include?([x, y-1])
  end
  nodes
end

def can_forward(path)
  return true if path.size < 4
  x1, y1 = path[-1]
  x2, y2 = path[-2]
  x3, y3 = path[-3]
  x4, y4 = path[-4]
  if (x1 == x2 && x2 == x3 && x3 == x4) || (y1 == y2 && y2 == y3 && y3 == y4)
    false
  else
    true
  end
end

def direction(path)
  x1, y1 = path[-1]
  x2, y2 = path[-2]
  if x1 == x2
    y1 > y2 ? 'right' : 'left'
  else
    x1 > x2 ? 'down' : 'up'
  end
end

def path_value(data, path)
  path.inject(0) do |sum, point|
    x, y = point
    sum + data[x][y]
  end
rescue => e
  binding.break
end

def dijkstras(data)
  visited = {}
  visited[[0, 0]] = 0
  pool = {}
  pos = [0, 0]
  while true
    x, y = pos
    nodes = []
    nodes << [x-1, y] if x > 0
    nodes << [x+1, y] if x < (data.size-1)
    nodes << [x, y-1] if y > 0
    nodes << [x, y+1] if y < (data[0].size-1)
    nodes.select do |pn|
      visited[pn].nil?
    end.each do |pn|
      v = visited[pos] + data[x][y]
      pool[pn] = v if !pool[pn] || pool[pn] > v
    end
    break if pool.empty?

    np, nk = pool.sort_by { |k, v| v }.first
    pool.delete(np)
    visited[np] = nk
    pos = np
  end
  p visited
  visited[[data.size-1, data[0].size-1]]
end

def track(data, pos, direction, traced={}, count=0)
  x, y = pos
  if x == (data.size-1) && y == (data[0].size-1)
    p traced.values.sum + data.last.last - data[0][0]
    return data.last.last
  end
  traced = traced.clone
  traced["#{x}-#{y}"] = data[x][y]
  tmp = []
  case direction
  when 'right'
    if count < 3 && y < (data[0].size-1) && !traced["#{x}-#{y+1}"]
      re = track(data, [x, y+1], 'right', traced.clone, count+1)
      tmp << (data[x][y+1] + re) if re
    end
    if x < (data.size-1) && !traced["#{x+1}-#{y}"]
      re = track(data, [x+1, y], 'down', traced.clone)
      tmp << (data[x+1][y] + re) if re
    end
    if x > 0 && !traced["#{x-1}-#{y}"]
      re = track(data, [x-1, y], 'up', traced.clone)
      tmp << (data[x-1][y] + re) if re
    end
  when 'down'
    if count < 3 && x < (data.size-1) && !traced["#{x+1}-#{y}"]
      re = track(data, [x+1, y], 'down', traced.clone, count+1)
      tmp << (data[x+1][y] + re) if re
    end
    if y < (data[0].size-1) && !traced["#{x}-#{y+1}"]
      re = track(data, [x, y+1], 'right', traced.clone)
      tmp << (data[x][y+1] + re) if re
    end
    if y > 0 && !traced["#{x}-#{y-1}"]
      re = track(data, [x, y-1], 'left', traced.clone)
      tmp << (data[x][y-1] + re) if re
    end
  when 'left'
    if count < 3 && y > 0 && !traced["#{x}-#{y-1}"]
      re = track(data, [x, y-1], 'left', traced.clone, count+1)
      tmp << (data[x][y-1] + re) if re
    end
    if x < (data.size-1) && !traced["#{x+1}-#{y}"]
      re = track(data, [x+1, y], 'down', traced.clone)
      tmp << (data[x+1][y] + re) if re
    end
    if x > 0 && !traced["#{x-1}-#{y}"]
      re = track(data, [x-1, y], 'up', traced.clone)
      tmp << (data[x-1][y] + re) if re
    end
  when 'up'
    if y < (data[0].size-1) && !traced["#{x}-#{y+1}"]
      re = track(data, [x, y+1], 'right', traced.clone)
      tmp << (data[x][y+1] + re) if re
    end
    if count < 3 && x > 0 && !traced["#{x-1}-#{y}"]
      re = track(data, [x-1, y], 'up', traced.clone, count+1)
      tmp << (data[x-1][y] + re) if re
    end
    if y > 0 && !traced["#{x}-#{y-1}"]
      re = track(data, [x, y-1], 'left', traced.clone)
      tmp << (data[x][y-1] + re) if re
    end
  else
    raise "wtf"
  end
  tmp.empty? ? false : tmp.min
  # raise 'wtf' if tmp.empty?
  # tmp.min + 1
end

# def dfs(data)
#   [track(data, [0, 0], 'right', traced={}, count=0), track(data, [0, 0], 'down', traced={}, count=0)].min
# end

def p2(data)
  
end

p p1(data)
p p2(data)
