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
    bfs(target, buttons)
  end.sum
end

def bfs(target, buttons)
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
    dfs(buttons, Array.new(target.size, 0), target)
  end.sum
end

def valid?(buttons, counter, target)
  state = Array.new(target.size, 0)
  buttons.each_with_index do |button, i|
    button.each do |b|
      state[b] += counter[i]
    end
  end
  state == target
end

def dfs(buttons, state, target)
  arrays = buttons.map do |button|
    max = button.map { |b| target[b] }.max
    (0..max).to_a
  end

  result = -1
  arrays[0].product(*arrays[1..-1]).each do |counter|
    if valid?(buttons, counter, target)
      re = counter.sum
      if result == -1 || re < result
        result = re
      end
    end
  end

  result
end

def press(button, state)
  button.each { |b| state[b] += 1}
end

def overflow?(state, target)
  state.map.with_index { |k, i| k > target[i] }.any?(true)
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
