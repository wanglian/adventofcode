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

def convert(x, y)
  [x + 1, y + 1]
end

def p2(data)
  xs = data.map { |pos| pos[0] }.uniq.sort
  ys = data.map { |pos| pos[1] }.uniq.sort
  w = xs.size
  h = ys.size

  # coordinate compression
  x_index = {}
  xs.each_with_index { |x, i| x_index[x] = i }
  y_index = {}
  ys.each_with_index { |y, i| y_index[y] = i }

  reds_idx = data.map { |x, y| [x_index[x], y_index[y]] }
  n = reds_idx.size

  wall = Array.new(w+2) { Array.new(h+2, false) }
  visited = Array.new(w+2) { Array.new(h+2, false) }

  size = reds_idx.size
  reds_idx.each_with_index do |red, i|
    x1, y1 = red
    x2, y2 = reds_idx[(i+1)%size]

    ex1, ey1 = convert(x1, y1)
    ex2, ey2 = convert(x2, y2)

    if x1 == x2
      y1, y2 = [ey1, ey2].sort
      (y1..y2).each do |y|
        wall[ex1][y] = true
      end
    else
      x1, x2 = [x1, x2].sort
      (x1..x2).each do |x|
        wall[x][ey1] = true
      end
    end
  end

  # flood fill
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
  w.times do |cx|
    h.times do |cy|
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
  (0..(w-1)).each do |i|
    xsum = 0
    (0..(h-1)).each do |j|
      xsum += allowed[i][j]
      prefix[i+1][j+1] = prefix[i][j+1] + xsum
    end
  end

  reds_idx.combination(2).sort_by do |p1, p2|
    - calc_area(p1, p2)
  end.each do |p1, p2|
    return calc_real(xs, ys, p1, p2) if valid?(prefix, p1, p2)
  end
  0
end

def calc_real(xs, ys, p1, p2)
  x1, y1 = p1
  x2, y2 = p2
  x1, x2 = [x1, x2].sort
  y1, y2 = [y1, y2].sort
  real_w = (xs[x2] - xs[x1]).abs + 1
  real_h = (ys[y2] - ys[y1]).abs + 1
  real_w * real_h
end

def calc_sum(prefix, p1, p2)
  x1, y1 = p1
  x2, y2 = p2
  x1, x2 = [x1, x2].sort
  y1, y2 = [y1, y2].sort
  prefix[x2 + 1][y2 + 1] -
    prefix[x1][y2 + 1] -
    prefix[x2 + 1][y1] +
    prefix[x1][y1]
end

def valid?(prefix, p1, p2)
  calc_area(p1, p2) == calc_sum(prefix, p1, p2)
end

# def valid?(data, lines, p1, p2)
#   # 1 no red tiles inside the rectangle
#   data.each do |pos|
#     return false if inside_rectangle?(p1, p2, pos)
#   end
#   # 2 vertex should be inside the loop
#   x1, y1 = p1
#   x2, y2 = p2
#   [[x1, y2], [x2, y1]].each do |pos|
#     return false unless inside?(lines, pos)
#   end
#   # 3 any point should be inside the loop
#   x = (x1 + x2) / 2
#   y = (y1 + y2) / 2
#   return false unless inside?(lines, [x, y])
#   # 4 no edge inside the rectangle
#   lines.each do |line|
#     return false if edge_inside_rectangle?(line, p1, p2)
#   end
#   true
# end
#
# def inside_rectangle?(p1, p2, pos)
#   x1, y1 = p1
#   x2, y2 = p2
#   x1, x2 = [x1, x2].sort
#   y1, y2 = [y1, y2].sort
#   x, y = pos
#   x > x1 && x < x2 && y > y1 && y < y2
# end
#
# def edge_inside_rectangle?(line, p1, p2)
#   x1, y1 = p1
#   x2, y2 = p2
#   x1, x2 = [x1, x2].sort
#   y1, y2 = [y1, y2].sort
#   l1, l2 = line
#   lx1, ly1 = l1
#   lx2, ly2 = l2
#   if lx1 == lx2
#     ly1, ly2 = [ly1, ly2].sort
#     (lx1 > (x1+1) && lx1 < (x2-1)) && ((ly1 <= y1 && ly2 > y1) || (ly1 > y1 && ly1 <= y2))
#   else
#     lx1, lx2 = [lx1, lx2].sort
#     (ly1 > (y1+1) && ly1 < (y2-1)) && ((lx1 <= x1 && lx2 > x1) || (lx1 > x1 && lx1 <= x2))
#   end
# end

# def intersect?(line, p1, p2)
#   x1, y1 = p1
#   x2, y2 = p2
#   pl1, pl2 = line
#   x3, y3 = pl1
#   x4, y4 = pl2
#
#   denom = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)
#
#   # Check if lines are parallel (denominator is zero)
#   if denom == 0.0
#     # Handle collinear case (overlap check required, omitted for general non-parallel cases)
#     return false
#   end
#
#   ua = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / denom
#   ub = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / denom
#
#   # The segments intersect only if ua and ub are both between 0 and 1
#   ua > 0.0 && ua < 1.0 && ub > 0.0 && ub < 1.0
# end

# def cast?(line, pos, direction)
#   p1, p2 = line
#   x1, y1 = p1
#   x2, y2 = p2
#   x, y = pos
#   if x1 == x2
#     ymin, ymax = [y1, y2].sort
#     case direction
#     when 'L'
#       x >= x1 && y >= ymin && y <= ymax
#     when 'R'
#       x <= x1 && y >= ymin && y <= ymax
#     when 'U'
#       x == x1 && y > ymax
#     when 'D'
#       x == x1 && y < ymin
#     end
#   else
#     xmin, xmax = [x1, x2].sort
#     case direction
#     when 'U'
#       y >= y1 && x >= xmin && x <= xmax
#     when 'D'
#       y <= y1 && x >= xmin && x <= xmax
#     when 'L'
#       y == y1 && x > xmax
#     when 'R'
#       y == y1 && x < xmin
#     end
#   end
# end
#
# @line_cache = {}
# def on_lines?(lines, pos)
#   return @line_cache[pos] if @line_cache[pos]
#
#   result = false
#   x, y = pos
#   lines.each do |line|
#     p1, p2 = line
#     x1, y1 = p1
#     x2, y2 = p2
#     if x1 == x2
#       ymin, ymax = [y1, y2].sort
#       if x == x1 && y >= ymin && y <= ymax
#         result = true
#         break
#       end
#     else
#       xmin, xmax = [x1, x2].sort
#       if y == y1 && x >= xmin && x <= xmax
#         result = true
#         break
#       end
#     end
#   end
#
#   @line_cache[pos] = result
#   result
# end
#
# @inside_cache = {}
# def inside?(lines, pos)
#   return @inside_cache[pos] if @inside_cache[pos]
#
#   if on_lines?(lines, pos)
#     result = true
#   else
#     result = true
#     ['L', 'R', 'U', 'D'].each do |direction|
#       count = lines.sum { |line| cast?(line, pos, direction) ? 1 : 0 }
#       if count % 2 == 0
#         result = false
#         break
#       end
#     end
#   end
#
#   @inside_cache[pos] = result
#   result
# end

# def valid?(lines, p1, p2)
#   x1, y1 = p1
#   x2, y2 = p2
#   xmin, xmax = [x1, x2].sort
#   ymin, ymax = [y1, y2].sort
#
#   (xmin..xmax).each do |x|
#     return false unless inside?(lines, [x, y1])
#     return false unless inside?(lines, [x, y2])
#   end
#   (ymin..ymax).each do |y|
#     return false unless inside?(lines, [x1, y])
#     return false unless inside?(lines, [x2, y])
#   end
#   true
# end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
