require './utils.rb'

data = get_input("10").map do |row|
  target = row.scan(/\[(.*?)\]/).flatten.first
  buttons = row.scan(/\((.*?)\)/).flatten.map do |b|
    b.split(',').map(&:to_i)
  end
  joltage = row.scan(/\{(.*?)\}/).flatten.first.split(",").map(&:to_i)
  [target, buttons, joltage]
end

def p1(data)
  # binding.break
  data.map do |target, buttons|
    min_presses(target, buttons)
  end.sum
end

def min_presses(target, buttons)
  size = target.size
  max = 1 << size
  target = target.split('').map { |l| l == '#' ? 1 : 0 }.join.to_i(2)
  start = 0
  return 0 if start == target

  buttons = buttons.map do |bs|
    bs.map {|b| 1 << (size - b - 1)}.sum
  end

  visited = Array.new(max, false)
  presses = Array.new(max, 0)
  # BFS
  visited[start] = true
  queue = [start]
  while state = queue.shift
    press = presses[state]
    buttons.each do |button|
      next_state = state ^ button
      next if visited[next_state]

      return press + 1 if next_state == target

      visited[next_state] = true
      presses[next_state] = press + 1
      queue << next_state
    end
  end
  raise "oops"
end

def p2(data)
  data.map do |ignore, buttons, target|
    min_presses2(buttons, target)
  end.sum
end

def min_presses2(buttons, target)
  # TODO
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
