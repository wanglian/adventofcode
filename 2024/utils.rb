require "base64"
require 'debug'

def get_input(day)
  File.open("input/day#{day}.txt").readlines.map(&:chomp)
end

def with_time
  t1 = Time.now
  p "S: #{t1}"
  yield
  t2 = Time.now
  p "E: #{t2}"
  p "Time used: #{t2 - t1}"
end

def dijkstra(nodes, ns, ne)
  return 0 if ns == ne

  visited = {}
  visited[ns] = 0
  pool = {}
  pos = ns
  while true
    nodes[pos].select do |pn|
      visited[pn].nil?
    end.select do |pn|
      v = visited[pos] + 1
      pool[pn] = v if !pool[pn] || pool[pn] > v
    end
    break if pool.empty?

    np, nk = pool.sort_by { |k, v| v }.first
    pool.delete(np)
    visited[np] = nk
    pos = np
  end
  visited[ne]
end
