require './utils.rb'

data = get_input("18").map {|row| row.split(' ')}

def p1(data)
  map = []
  x, y = 0, 0
  last = data.last[0]
  data.each do |row|
    direction = row[0]
    steps = row[1].to_i
    map[x] ||= []
    map[x][y] = get_turn(direction, last)
    last = direction
    x, y = move(map, [x, y], direction, steps)
  end
  result = 0
  map.each_with_index do |row, i|
    row.each_with_index do |v, j|
      result += 1 if v || inside?(map, i, j)
    end
  end
  p CACHE.count
  result
end

PIPES = %w(| - L J 7 F)
CACHE = {}
def inside?(data, x, y)
  return false if x == 0 || y == 0
  return CACHE[[x-1, y]] if CACHE[[x-1, y]]
  return CACHE[[x, y-1]] if CACHE[[x, y-1]]
  row = data[x]
  i= y-1
  count = 0
  last = nil
  while i >= 0
    if PIPES.include?(row[i])
      if last.nil?
        count += 1
        last = row[i] if %w(7 J).include?(row[i])
      elsif row[i] != '-'
        case row[i]
        when 'L'
          count += 1 if last == 'J'
        when 'F'
          count += 1 if last == '7'
        end
        last = nil
      end
    else
      last = nil
    end
    i -= 1
  end
  # binding.break
  return false unless (count % 2) == 1

  count = 0
  i = y+1
  last = nil
  while i < row.size
    if PIPES.include?(row[i])
      if last.nil?
        count += 1
        last = row[i] if %w(L F).include?(row[i])
      elsif row[i] != '-'
        case row[i]
        when 'J'
          count += 1 if last == 'L'
        when '7'
          count += 1 if last == 'F'
        end
        last = nil
      end
    else
      last = nil
    end
    i += 1
  end
  # binding.break
  return false unless (count % 2) == 1

  i = x-1
  count = 0
  last = nil
  while i >= 0
    if PIPES.include?(data[i][y])
      if last.nil?
        count += 1
        last = data[i][y] if %w(L J).include?(data[i][y])
      elsif data[i][y] != '|'
        case data[i][y]
        when '7'
          count += 1 if last == 'J'
        when 'F'
          count += 1 if last == 'L'
        end
        last = nil
      end
    else
      last = nil
    end
    i -= 1
  end
  # binding.break
  return false unless (count % 2) == 1

  i = x+1
  count = 0
  last = nil
  while i < data.size
    # binding.break
    if PIPES.include?(data[i][y])
      if last.nil?
        count += 1
        last = data[i][y] if %w(7 F).include?(data[i][y])
      elsif data[i][y] != '|'
        case data[i][y]
        when 'J'
          count += 1 if last == '7'
        when 'L'
          count += 1 if last == 'F'
        end
        last = nil
      end
    else
      last = nil
    end
    i += 1
  end
  # binding.break
  result = (count % 2) == 1
  CACHE[[x, y]] = result ? 'T' : 'F'
  result
end

def move(map, pos, direction, steps)
  x, y = pos
  case direction
  when 'R'
    steps.times do |i|
      map[x][y+i+1] ||= '-'
    end
    [x, y+steps]
  when 'U'
    k = x-steps
    if k < 0
      k.abs.times { map.unshift([]) }
      k = 0
    end
    steps.times do |i|
      map[k+i] ||= []
      map[k+i][y] ||= '|'
    end
    [k, y]
  when 'D'
    steps.times do |i|
      map[x+i+1] ||= []
      map[x+i+1][y] ||= '|'
    end
    [x+steps, y]
  when 'L'
    k = y-steps
    if k < 0
      k.abs.times do
        map.each { |row| row.unshift(nil) }
      end
      k = 0
    end
    steps.times do |i|
      map[x][k+i] ||= '-'
    end
    [x, k]
  end
end

def get_turn(direction, last)
  case direction
  when 'R'
    case last
    when 'D'
      'L'
    when 'U'
      'F'
    else
      '-'
    end
  when 'D'
    case last
    when 'L'
      'F'
    when 'R'
      '7'
    else
      '|'
    end
  when 'L'
    case last
    when 'U'
      '7'
    when 'D'
      'J'
    else
      '-'
    end
  when 'U'
    case last
    when 'L'
      'L'
    when 'R'
      'J'
    else
      '|'
    end
  end
end

# polygon area
def p2(data)
  map = []
  x, y = 0, 0
  last = data.last[0]
  data.each do |row|
    direction = parse_direction(row[2][7].to_i)
    steps = row[2][2, 5].to_i(16)
    p "#{direction} #{steps}"
    binding.break
    map[x] ||= []
    map[x][y] = get_turn(direction, last)
    last = direction
    x, y = move(map, [x, y], direction, steps)
  end
  
end

def parse_direction(s)
  case s
  when 0
    'R'
  when 1
    'D'
  when 2
    'L'
  when 3
    'U'
  end
end

with_time {p p1(data)}
p p2(data)
