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

def p2(data, workers, visited)
  tt = data.select { |s, v| v[0] > 0 && !visited.include?(s) }
  return 0 if tt.empty?
  re = workers.map.with_index do |worker, i|
    cc = data.select { |s, v| v[0] > 0 && !visited.include?(s) }
    cc.map do |c|
      dd = dijkstra(data, worker[0], c)
      worker[1] -= dd
      re = 0
      if data[worker[0]][0] > 0
        worker[1] -= 1
        re += data[worker[0][0]] * (worker[1] - 1)
      end
      pvisited = visited.clone
      pvisited << worker[0]
      re += p2(data, workers, )
    end
    kk = p2(data, )
    start, mm = worker
    pp = probe2(data, start, mm, visited.clone)
    [pp[0], i, pp[2]]
  end.sort
  p re
  re = re.last
  worker = workers[re[1]]
  worker[1] -= dijkstra(data, worker[0], re[2])
  worker[0] = re[2]
  visited << worker[0]
  p workers
  kk = data[worker[0]][0] * (worker[1] - 1)
  p kk
  kk + p2(data, workers, visited)
end

data = parse(data)

# part 1
with_time { p calc(data, 'AA', 30) }

# part 2
# with_time { p p2(data, [['AA',26,], ['AA', 26]], ['AA'])}

# p probe2(data, 'AA', 26, ['DD'])

