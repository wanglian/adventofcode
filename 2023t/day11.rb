require './utils.rb'

data = get_input("11").map {|row| row.split('')}

def p1(data)
  expand(data)

  find_galaxies(data).combination(2).inject(0) do |sum, com|
    sum + distance(com)
  end
end

def p1_new(data)
  expand_distance(data, 2)
end

def expand(data)
  i = 0
  while i < data.size
    if data[i].count('#') == 0
      data.insert i, Array.new(data[i].size, '.')
      i += 1
    end
    i += 1
  end
  j = 0
  while j < data[0].size
    empty = true
    data.each do |row|
      if row[j] == '#'
        empty = false
        break
      end
    end
    if empty
      data.each do |row|
        row.insert j, '.'
      end
      j += 1
    end
    j += 1
  end
  data
end

def find_galaxies(data)
  result = []
  data.each_with_index do |row, x|
    row.each_with_index do |v, y|
      result << [x, y] if v == '#'
    end
  end
  result
end

def distance(com)
  p1, p2 = com
  x1, y1 = p1
  x2, y2 = p2
  (x1-x2).abs + (y1-y2).abs
end

def p2(data)
  expand_distance(data, 1000000)
end

def expand_distance(data, n)
  find_galaxies(data).combination(2).inject(0) do |sum, gp|
    sum + distance(gp) + calc_empties(data, gp) * (n-1)
  end
end

def calc_empties(data, com)
  p1, p2 = com
  x1, y1 = p1
  x2, y2 = p2

  result = 0
  x = [x1, x2].min + 1
  xmax = [x1, x2].max
  while x < xmax
    result += 1 if data[x].count('#') == 0
    x += 1
  end
  y = [y1, y2].min + 1
  ymax = [y1, y2].max
  while y < ymax
    empty = true
    data.each do |row|
      if row[y] == '#'
        empty = false
        break
      end
    end
    result += 1 if empty
    y += 1
  end
  result
end

with_time {p p1(data)}
with_time {p p2(data)}
