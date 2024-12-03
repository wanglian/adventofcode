require './utils.rb'

data = get_input("16")

def parse(data)
  valves = {}
  data.each do |row|
    desc = row.split(';')
    key = desc[0].scan(/[A-Z][A-Z]/).first
    rate = desc[0].scan(/\d+/).first.to_i
    to = desc[1].scan(/[A-Z][A-Z]/)
    valves[key] = [rate, to]
  end
  valves
end

def pick(pool)
  np = pool.sort_by { |k, v| v }.first
  pool.delete(np[0])
  np
end

@d_cache = {}
def dijkstra(data, s, e)
  c = @d_cache[[s, e]] || @d_cache[[e, s]]
  return c if c
  return 0 if s == e
  visited = {}
  visited[s] = 0
  pool = {}
  pos = s
  while true
    data[pos][1].select do |pn|
      visited[pn].nil?
    end.select do |pn|
      v = visited[pos] + 1
      pool[pn] = v if !pool[pn] || pool[pn] > v
    end
    break if pool.empty?

    np, nk = pick(pool)
    visited[np] = nk
    pos = np
  end
  re = visited[e]
  @d_cache[[s, e]] = re
  re
end

# DFS
def calc(data, start, minutes, valves_opened=[])
  raise "no start: #{start}" unless data[start]

  rate = data[start][0]
  return rate if minutes == 2
  return 0 if minutes < 2

  valves_left = data.select do |valve, attrs|
    attrs[0] > 0 &&
      valve != start &&
      !valves_opened.include?(valve) &&
      minutes - 1 > dijkstra(data, start, valve)
  end

  result = rate * (minutes - 1)
  if valves_left.size > 0
    result += valves_left.map do |valve, attrs|
      v_minutes = minutes - dijkstra(data, start, valve)
      v_minutes -= 1 if rate > 0
      nvisited = valves_opened.clone
      nvisited << start
      calc(data, valve, v_minutes, nvisited)
    end.max
  end

  result
end

@p2_cache = {}
def p2(data, workers, visited)
  p workers, visited
  result = workers.inject(0) do |sum, w|
    sum + (w[1] - 1) * data[w[0]][0]
  end
  tt = data.select { |s, v| v[0] > 0 && !visited.include?(s) }.keys
  return result if tt.empty?

  result + if tt.size == 1
    workers.map do |worker|
      dd = dijkstra(data, worker[0], tt.first)
      dd += 1 if data[worker[0]][0] > 0
      worker[1] - dd - 1
    end.max * data[tt.first][0]
  else
    tt.permutation(workers.size).map do |pp|
      if @p2_cache["#{pp}-#{visited}"]
        @p2_cache["#{pp}-#{visited}"]
      else
        p_visited = visited.clone
        p_workers = workers.select do |w|
          w[1] > 2
        end.map.with_index do |worker, i|
          dd = dijkstra(data, worker[0], pp[i])
          dd += 1 if data[worker[0]][0] > 0
          p_visited << pp[i]
          mm = worker[1] - dd
          # binding.b if mm < 2
          [pp[i], mm]
        end.select { |w| w[1] > 1 }
        re = if p_workers.empty?
          0
        else
          p2(data, p_workers, p_visited)
        end
        @p2_cache["#{pp}-#{visited}"] = re
        re
      end
    end.max || 0
  end
end

data = parse(data)

# part 1
# with_time { p calc(data, 'AA', 30) }

# part 2
# with_time { p p2(data, [['AA',26,], ['AA', 26]], ['AA'])}
# with_time { p p2(data, [['AA',26,], ['AA', 22], ['AA', 22]], ['AA'])}
# with_time { p p2(data, [['AA',26,], ['AA', 22], ['AA', 18], ['AA', 18]], ['AA'])}
# with_time { p p2(data, [['AA',26,], ['AA', 22], ['AA', 18], ['AA', 14], ['AA', 14]], ['AA'])}
# with_time { p p2(data, [['AA',26,], ['AA', 22], ['AA', 18], ['AA', 14], ['AA', 10], ['AA', 10]], ['AA'])}
# with_time { p p2(data, [['AA',26,], ['AA', 22], ['AA', 18], ['AA', 14], ['AA', 10], ['AA', 6], ['AA', 6]], ['AA'])}
# with_time { p p2(data, [['AA',26,], ['AA', 22], ['AA', 18], ['AA', 14], ['AA', 10], ['AA', 6], ['AA', 2], ['AA', 2]], ['AA'])}

# p probe2(data, 'AA', 26, ['DD'])

