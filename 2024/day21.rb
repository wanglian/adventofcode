require './utils.rb'

data = get_input("21").map { |row| row.split('') }

# n_keypad
# [
#   [7, 8, 9],
#   [4, 5, 6],
#   [1, 2, 3],
#   [ , 0, 'A']
# ]

# d_keypad
# [
#   [   , '^', 'A'],
#   ['<', 'v', '>']
# ]

def n_pos(d)
  case d
  when '0'
    [3, 1]
  when '1'
    [2, 0]
  when '2'
    [2, 1]
  when '3'
    [2, 2]
  when '4'
    [1, 0]
  when '5'
    [1, 1]
  when '6'
    [1, 2]
  when '7'
    [0, 0]
  when '8'
    [0, 1]
  when '9'
    [0, 2]
  when 'A'
    [3, 2]
  end
end

def n_moves(p1, p2, path=[])
  # p p1, p2, path
  # binding.break
  return [path << 'A'] if p1 == p2

  x1, y1 = p1
  x2, y2 = p2
  result = []

  if x1 > x2
    tp = path.dup << '^'
    result += n_moves([x1-1, y1], p2, tp)
  elsif x1 < x2
    if x1 == 2 && y1 == 0
      # skip
    else
      tp = path.dup << 'v'
      result += n_moves([x1+1, y1], p2, tp)
    end
  end
  if y1 > y2
    if x1 == 3 && y1 == 1
      # skip
    else
      tp = path.dup << '<'
      result += n_moves([x1, y1-1], p2, tp)
    end
  elsif y1 < y2
    tp = path.dup << '>'
    result += n_moves([x1, y1+1], p2, tp)
  end

  result
end

def shortest_n(code)
  nc = [3, 2]
  paths = [[]]
  code.each do |d|
    nd = n_pos(d)
    paths = paths.inject([]) do |sum, path|
      sum + n_moves(nc, nd, path)
    end
    nc = nd
  end
  paths
end

def d_pos(d)
  case d
  when '<'
    [1, 0]
  when 'v'
    [1, 1]
  when '>'
    [1, 2]
  when '^'
    [0, 1]
  when 'A'
    [0, 2]
  end
end

def d_moves(p1, p2, path=[])
  return [path << 'A'] if p1 == p2

  x1, y1 = p1
  x2, y2 = p2
  result = []

  if x1 > x2
    if x1 == 1 && y1 == 0
      # skip
    else
      tp = path.dup << '^'
      result += d_moves([x1-1,y1], p2, tp)
    end
  elsif x2 > x1
    tp = path.dup << 'v'
    result += d_moves([x1+1,y1], p2, tp)
  end

  if y1 > y2
    if x1 == 0 && y1 == 1
      # skip
    else
      tp = path.dup << '<'
      result += d_moves([x1,y1-1], p2, tp)
    end
  elsif y2 > y1
    tp = path.dup << '>'
    result += d_moves([x1,y1+1], p2, tp)
  end

  result
end

def shortest_d(code)
  nc = [0, 2]
  paths = [[]]
  code.each do |d|
    nd = d_pos(d)
    paths = paths.inject([]) do |sum, path|
      sum + d_moves(nc, nd, path)
    end
    nc = nd
  end
  paths
end

@cache = {}
def steps(code, n=1)
  count = @cache[[code, n]] || 0
  return count if count > 0

  count =
    shortest_d(code).map do |path|
      if n == 1 || path.size == 1
        path.size
      else
        path.join.split('A').map do |code|
          code = code.split('') << 'A'
          steps(code, n-1)
        end.sum
      end
    end.min

  @cache[[code, n]] = count
  count
end

def p1(data, n=2)
  data.inject(0) do |sum, code|
    p code.join
    re = shortest_n(code).map do |path|
      path.join.split('A').map do |pc|
        pc = pc.split('') << 'A'
        steps(pc, n)
      end.sum
    end.min
    p re
    sum + re * code[0, 3].join.to_i
  end
end

def p2(data)
  p1(data, 25)
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
