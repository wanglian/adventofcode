require './utils.rb'

data = get_input("13")

def parse(data)
  machines = []
  machine = [] # [[Ax, Ay], [Bx, By], [Px, Py]]
  data.each do |row|
    if row.empty?
      machines << machine
      machine = []
    else
      machine << row.scan(/\d+/).map(&:to_i)
    end
  end
  machines << machine
  machines
end

def calc(machine, limit=0)
  a, b, prize = machine
  ax, ay = a
  bx, by = b
  px, py = prize

  if (px * by - py * bx) % (ax * by - ay * bx) == 0
    x = (px * by - py * bx) / (ax * by - ay * bx)
  else
    return 0
  end

  if (px * ay - py * ax) % (bx * ay - by * ax) == 0
    y = (px * ay - py * ax) / (bx * ay - by * ax)
  else
    return 0
  end

  return 0 if limit > 0 && (x > limit || y > limit)
  3 * x + y
end

def p1(data)
  machines = parse(data)
  result = 0
  machines.each do |machine|
    tokens = calc(machine, 100)
    result += tokens if tokens > 0
  end
  result
end

def p2(data)
  machines = parse(data)
  machines.each do |machine|
    machine[2][0] += 10000000000000
    machine[2][1] += 10000000000000
  end
  result = 0
  machines.each do |machine|
    tokens = calc(machine)
    result += tokens if tokens > 0
  end
  result
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
