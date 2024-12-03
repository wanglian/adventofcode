data = File.open('input/day09.txt').readlines.map(&:chomp)
  .map { |row| row.split(' ') }
  
def check(h, t)
  if (h[1] - t[1]).abs > 1 && (h[0] - t[0]).abs > 1
    t[1] = h[1] > t[1] ? h[1] - 1 : h[1] + 1
    t[0] = h[0] > t[0] ? h[0] - 1 : h[0] + 1
  elsif (h[1] - t[1]).abs > 1
    t[1] = h[1] > t[1] ? h[1] - 1 : h[1] + 1
    t[0] = h[0]
  elsif (h[0] - t[0]).abs > 1
    t[0] = h[0] > t[0] ? h[0] - 1 : h[0] + 1
    t[1] = h[1]
  end
end

def move(rope, motion, visited)
  steps = motion[1].to_i
  steps.times do
    case motion[0]
    when 'U'
      rope[0][1] += 1
    when 'D'
      rope[0][1] -= 1
    when 'R'
      rope[0][0] += 1
    when 'L'
      rope[0][0] -= 1
    end
    (0..(rope.length-2)).each do |k|
      check(rope[k], rope[k + 1])
    end
    visited[rope.last.join('#')] = true
  end
end

def p1(data, n)
  visited = {}
  rope = n.times.map { [0, 0] }
  data.each { |motion| move(rope, motion, visited) }
  visited.size
end

p p1(data, 2)
p p1(data, 10)
