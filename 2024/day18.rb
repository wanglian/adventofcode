require './utils.rb'

data = get_input("18").map { |row| row.split(',').map(&:to_i) }

def p1(data)
  # binding.break
  # range, bytes = 7, 12 # test
  range, bytes = 71, 1024
  grid = []
  range.times { |r| grid << Array.new(range, '.') }
  bytes.times do |i|
    x, y = data[i]
    grid[y][x] = '#'
  end
  # grid.each { |row| p row.join }

  ns = [0, 0]
  ne = [range-1, range-1]
  visited = dijkstra(grid, ns, ne)
  visited[ne]
end

def neighbors(data, pos)
  nodes = []
  x, y = pos
  nodes << [x-1, y] if x > 0 && data[x-1][y] != '#'
  nodes << [x, y-1] if y > 0 && data[x][y-1] != '#'
  nodes << [x+1, y] if x < (data.size-1) && data[x+1][y] != '#'
  nodes << [x, y+1] if y < (data[0].size-1) && data[x][y+1] != '#'
  nodes
end

def dijkstra(data, ns, ne)
  visited = {}
  visited[ns] = 0
  pool = {}
  pos = ns
  while true
    # binding.break
    neighbors(data, pos).select do |pn|
      visited[pn].nil?
    end.map do |pn|
      v = visited[pos]
      v += 1
      if !pool[pn] || pool[pn] > v
        pool[pn] = v
      end
    end
    break if pool.empty?

    np, nk = pool.sort_by { |k, v| v }.first
    pool.delete(np)
    visited[np] = nk
    pos = np
  end
  visited
end

def p2(data)
  # range, bytes = 7, 12 # test
  range, bytes = 71, 1024
  grid = []
  range.times { |r| grid << Array.new(range, '.') }
  bytes.times do |i|
    x, y = data[i]
    grid[y][x] = '#'
  end
  # grid.each { |row| p row.join }

  ns = [0, 0]
  ne = [range-1, range-1]
  while true
    x, y = data[bytes]
    grid[y][x] = '#'
    visited = dijkstra(grid, ns, ne)
    break unless visited[ne]
    bytes += 1
  end
  data[bytes].join(',')
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
