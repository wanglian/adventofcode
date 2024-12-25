require './utils.rb'

data = get_input("24")

def parse(data)
  gates, connections = {}, []
  first = true
  data.each do |row|
    if row.empty?
      first = false
      next
    end
    if first
      g = row.split(': ')
      gates[g[0]] = g[1].to_i
    else
      c = row.split(' -> ')
      connections << [c[0].split(' '), c[1]]
    end
  end
  [gates, connections]
end

def calc(v1, v2, operator)
  case operator
  when 'AND'
    v1 & v2
  when 'OR'
    v1 | v2
  when 'XOR'
    v1 ^ v2
  end
end

def calc_z(gates, connections)
  result = []
  while connections.size > 0
    tmp = []
    connections.each do |con|
      input, g = con
      g1, operator, g2 = input
      v1, v2 = gates[g1], gates[g2]
      if v1.nil? || v2.nil?
        tmp << con
        next
      end

      v = calc(v1, v2, operator)
      gates[g] = v
      result[g[1,2].to_i] = v if g[0] == 'z'
    end
    connections = tmp
  end
  result.reverse
end

def p1(data)
  # binding.break
  gates, connections = parse(data)
  calc_z(gates, connections).join.to_i(2)
end

def check_number(gate)

end

def init(k, size)
  x = Array.new size, 0
  x[k] = 1
  y = Array.new size, 0
  y[k] = 1
  result = {}
  size.times do |i|
    v = k == i ? 1 : 0
    result["x" + "%02d" % i] = v
    result["y" + "%02d" % i] = v
  end
  [x.reverse.join.to_i(2), y.reverse.join.to_i(2), result]
end

def p2(data)
  gates, connections = parse(data)

  xs = gates.filter { |k, v| k[0] == 'x' }

  size = xs.size
  i = 0
  while i < xs.size
    x, y, gs = init(i, size)
    unless calc_z(gs, connections).join.to_i(2) == (x + y)
      p i
    end
    i += 1
  end

  # manually check these bits
  # 4
  # 5
  # 10
  # 11
  # 22
  # 38

  ["pmd", "cgh", "z23", "frt", "z05", "tst", "z11", "sps"].sort.join ','
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
