require './utils.rb'

data = get_input("20").map { |row| row.split('') }

def find(data, s)
  data.each_with_index do |row, i|
    row.each_with_index do |v, j|
      return [i, j] if v == s
    end
  end
end

def neighbors(data, pos)
  nodes = []
  x, y = pos
  nodes << [x-1, y] if x > 1 && data[x-1][y] != '#'
  nodes << [x, y-1] if y > 1 && data[x][y-1] != '#'
  nodes << [x+1, y] if x < (data.size-2) && data[x+1][y] != '#'
  nodes << [x, y+1] if y < (data[0].size-2) && data[x][y+1] != '#'
  nodes
end

def dijkstra(data, ns, ne)
  visited = {}
  visited[ns] = 0
  pool = {}
  pos = ns
  while true
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

def manhattan(p1, p2)
  x1, y1 = p1
  x2, y2 = p2
  (x1-x2).abs + (y1-y2).abs
end

def p1(data, cheat=2)
  ns = find(data, 'S')
  ne = find(data, 'E')

  visited = dijkstra(data, ns, ne)
  path = visited.sort_by { |k, v| v }.map(&:first)

  i = 0
  result = {}
  target = 100
  while i < (path.size - target)
    j = i + target
    while j < path.size
      d = manhattan(path[i], path[j])
      if d <= cheat
        saving = j - i - d
        if saving >= target
          result[saving] ||= 0
          result[saving] += 1
        end
      end
      j += 1
    end
    i += 1
  end
  result.values.sum
end

def p2(data)
  p1(data, 20)
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
