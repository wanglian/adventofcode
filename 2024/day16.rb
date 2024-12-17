require './utils.rb'

data = get_input("16").map { |row| row.split('') }

def find(data, s)
  data.each_with_index do |row, i|
    row.each_with_index do |v, j|
      return [i, j] if v == s
    end
  end
end

def neighbors(data, pos)
  nodes = {}
  x, y = pos
  nodes[[x-1, y]] = '^' if x > 0 && data[x-1][y] != '#'
  nodes[[x, y-1]] = '<' if y > 0 && data[x][y-1] != '#'
  nodes[[x+1, y]] = 'v' if x < (data.size-1) && data[x+1][y] != '#'
  nodes[[x, y+1]] = '>' if y < (data[0].size-1) && data[x][y+1] != '#'
  nodes
end

def dijkstra(data, ns, ne)
  visited = {}
  visited[[ns, '>']] = 0
  pool = {}
  pos = ns
  direction = '>'
  while true
    neighbors(data, pos).select do |pn, d|
      visited[[pn, d]].nil?
    end.map do |pn, d|
      v = visited[[pos, direction]]
      v = direction == d ? v + 1 : v + 1001
      if !pool[[pn, d]] || pool[[pn, d]] > v
        pool[[pn, d]] = v
      end
    end
    break if pool.empty?

    np, nk = pool.sort_by { |k, v| v }.first
    pool.delete(np)
    visited[np] = nk
    pos, direction = np
  end
  visited
end

def p1(data)
  # binding.break
  ns = find(data, 'S')
  ne = find(data, 'E')
  visited = dijkstra(data, ns, ne)
  visited.select { |k, v| k[0] == ne }.values.min
end

def p2(data)
  ns = find(data, 'S')
  ne = find(data, 'E')
  visited = dijkstra(data, ns, ne)

  path = []
  pd, score = visited.select { |k, v| k[0] == ne }.min_by { |k, v| v }
  tmp = [[pd, score]]
  while true
    tt = []
    tmp.each do |t|
      pd, score = t
      pos, direction = pd
      path << pos

      x, y = pos
      pos = case direction
      when '^'
        [x+1, y]
      when '>'
        [x, y-1]
      when 'v'
        [x-1, y]
      when '<'
        [x, y+1]
      end
      next if pos == ns
      tt += visited.select { |k, v| k[0] == pos && (v == score - 1 || v == score - 1001) }.to_a
    end
    break if tt.empty?
    tmp = tt
  end
  path.uniq!
  path << ns

  # print
  path.each { |x, y| data[x][y] = 'O' }
  data.each { |row| p row.join }

  path.size
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
