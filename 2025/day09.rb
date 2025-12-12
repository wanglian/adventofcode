require './utils.rb'

data = get_input("09").map { |row| row.split(',').map(&:to_i) }

def p1(data)
  # binding.break
  re = 0
  data.combination(2).each do |p1, p2|
    a = calc_area(p1, p2)
    re = a if a > re
  end
  re
end

def calc_area(p1, p2)
  x1, y1 = p1
  x2, y2 = p2
  ((x1 - x2).abs + 1) * ((y1 - y2).abs + 1)
end

def calc_real_area(xs, ys, p1, p2)
  x1, y1 = p1
  x2, y2 = p2
  x1, x2 = [x1, x2].sort
  y1, y2 = [y1, y2].sort
  real_w = xs[x2] - xs[x1] + 1
  real_h = ys[y2] - ys[y1] + 1
  real_w * real_h
end

def calc_allowed(prefix, p1, p2)
  x1, y1 = p1
  x2, y2 = p2
  x1, x2 = [x1, x2].sort
  y1, y2 = [y1, y2].sort
  prefix[x2 + 1][y2 + 1] -
    prefix[x1][y2 + 1] -
    prefix[x2 + 1][y1] +
    prefix[x1][y1]
end

def convert(x, y)
  [x + 1, y + 1]
end

def p2(data)
  # coordinate compression
  xs = data.map(&:first).uniq.sort
  ys = data.map(&:last).uniq.sort
  w = xs.size
  h = ys.size

  x_index = {}
  xs.each_with_index { |x, i| x_index[x] = i }
  y_index = {}
  ys.each_with_index { |y, i| y_index[y] = i }

  reds_index = data.map { |x, y| [x_index[x], y_index[y]] }
  n = reds_index.size

  wall = Array.new(w+2) { Array.new(h+2, false) }
  reds_index.each_with_index do |red, i|
    x1, y1 = red
    x2, y2 = reds_index[(i+1)%n]

    ex1, ey1 = convert(x1, y1)
    ex2, ey2 = convert(x2, y2)

    if x1 == x2
      ey1, ey2 = [ey1, ey2].sort
      (ey1..ey2).each do |ey|
        wall[ex1][ey] = true
      end
    else
      ex1, ex2 = [ex1, ex2].sort
      (ex1..ex2).each do |ex|
        wall[ex][ey1] = true
      end
    end
  end

  # flood fill
  visited = Array.new(w+2) { Array.new(h+2, false) }
  dirs = [[1,0], [-1,0], [0,1], [0,-1]]
  queue = [[0,0]]
  visited[0][0] = true
  while queue.size > 0
    x, y = queue.shift
    dirs.each do |dx, dy|
      nx = x + dx
      ny = y + dy
      next unless nx.between?(0, w+1) && ny.between?(0, h+1)
      next if visited[nx][ny] || wall[nx][ny]

      visited[nx][ny] = true
      queue << [nx, ny]
    end
  end

  allowed = Array.new(w) { Array.new(h, 0) }
  (0...w).each do |cx|
    (0...h).each do |cy|
      ex, ey = convert(cx, cy)
      if wall[ex][ey]
        allowed[cx][cy] = 1
      else
        allowed[cx][cy] = 1 unless visited[ex][ey]
      end
    end
  end

  # prefix sum
  prefix = Array.new(w+1) { Array.new(h+1, 0) }
  (0...w).each do |i|
    xsum = 0
    (0...h).each do |j|
      xsum += allowed[i][j]
      prefix[i+1][j+1] = prefix[i][j+1] + xsum
    end
  end

  reds_index.combination(2).map do |p1, p2|
    [p1, p2, calc_real_area(xs, ys, p1, p2)]
  end.sort_by do |*, a|
    - a
  end.each do |p1, p2, real_area|
    area = calc_area(p1, p2)
    allowed_area = calc_allowed(prefix, p1, p2)
    return real_area if allowed_area == area
  end
  "oops, not found"
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
