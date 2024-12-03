data = File.open('input/day12.txt').readlines.map(&:chomp)

def find(data, char)
  data.each_with_index do |row, i|
    row.each_char.with_index do |c, j|
      return [i, j] if c == char
    end
  end
end

def val(char)
  char = 'a' if char == 'S'
  char = 'z' if char == 'E'
  char.ord
end

def pick(pool)
  np = pool.sort_by { |k, v| v }.first
  pool.delete(np[0])
  np
end

def dijkstra(data, s, e)
  pos = find(data, s)
  pos_e = nil
  visited = {}
  visited[pos] = 0
  pool = {}
  while true
    tmp = []
    tmp << [pos[0], pos[1] - 1] if pos[1] > 0
    tmp << [pos[0], pos[1] + 1] if pos[1] < data[0].length - 1
    tmp << [pos[0] - 1, pos[1]] if pos[0] > 0
    tmp << [pos[0] + 1, pos[1]] if pos[0] < data.length - 1
    tmp.select do |pn|
      visited[pn].nil?
    end.select do |pn|
      diff = val(data[pn[0]][pn[1]]) - val(data[pos[0]][pos[1]])
      if diff >= -1
        v = visited[pos] + 1
        pool[pn] = v if !pool[pn] || pool[pn] > v
      end
    end
    break if pool.empty?

    np, nk = pick(pool)
    visited[np] = nk
    pos = np

    if data[pos[0]][pos[1]] == e
      pos_e = pos
      break
    end
  end
  visited[pos_e]
end

# part 1
p dijkstra(data, 'E', 'S')
# part 2
p dijkstra(data, 'E', 'a')
