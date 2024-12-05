file = File.open 'input.txt'
data = file.readline.chomp

# data = 'target area: x=20..30, y=-10..-5'

ax, ay = data.gsub('target area: ', '').split(', ').map do |c|
  c.split('=')[1].split('..').map(&:to_i)
end
target = [ax, ay]

def move(point, v)
  x, y = point[0] + v[0], point[1] + v[1]
  # p "#{point} - #{v} => [#{x},#{y}]"
  vx = v[0]
  vx -= 1 if v[0] > 0
  vy = v[1] - 1
  [[x, y], [vx, vy]]
end

def check(point, target)
  if point[0] > target[0][1] || point[1] < target[1][0]
    1
  elsif point[0].between?(target[0][0], target[0][1]) && point[1].between?(target[1][0], target[1][1])
    0
  else
    -1
  end
end

def send(v, target)
  s = 0
  p = [0, 0]
  h = nil
  while true
    p, v = move p, v
    h = p[1] if !h || h < p[1]
    re = check p, target
    s += 1
    # p re
    if re < 0
      next
    elsif re > 0
      return -1
    else
      return 1
    end
  end
end

h = []

i = 1
while i <= ax[1]
  j = ay[0]
  while j < 1000
    re = send [i, j], target
    # p "#{i}-#{j}: #{re}"
    if re > 0
      h << [i, j]
    end
    j += 1
  end
  i += 1
end

p h.size

# p send([7,2], target)

# p check([21, -3], target)
