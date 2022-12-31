require './utils.rb'

data = get_input("23")
# p data

def north?(data, pos)
  x, y = pos
  y == 0 || case x
  when 0
    data[y-1][x, 2] == '..'
  when data.first.size - 1
    data[y-1][x-1, 2] == '..'
  else
    data[y-1][x-1, 3] == '...'
  end
end

def south?(data, pos)
  x, y = pos
  y == (data.size - 1) || case x
  when 0
    data[y+1][x, 2] == '..'
  when data.first.size - 1
    data[y+1][x-1, 2] == '..'
  else
    data[y+1][x-1, 3] == '...'
  end
end

def west?(data, pos)
  x, y = pos
  x == 0 || case y
  when 0
    data[y][x-1] == '.' && data[y+1][x-1] == '.'
  when data.size - 1
    data[y-1][x-1] == '.' && data[y][x-1] == '.'
  else
    (data[y-1][x-1] == '.' && data[y][x-1] == '.' && data[y+1][x-1] == '.')
  end
end

def east?(data, pos)
  x, y = pos
  x == (data.first.size - 1) || case y
  when 0
    data[y][x+1] == '.' && data[y+1][x+1] == '.'
  when data.size - 1
    data[y-1][x+1] == '.' && data[y][x+1] == '.'
  else
    (data[y-1][x+1] == '.' && data[y][x+1] == '.' && data[y+1][x+1] == '.')
  end
end

def can_move_all?(data, pos)
  x, y = pos
  north?(data, [x, y]) && south?(data, [x, y]) && west?(data, [x, y]) && east?(data, [x, y])
end

def prepend_row(data)
  data.unshift Array.new(data.first.size, '.').join
end

def append_row(data)
  data.push Array.new(data.first.size, '.').join
end

def prepend_column(data)
  data.each { |r| r.prepend('.') }
end

def append_column(data)
  data.each { |r| r << '.' }
end

def move(data, from, to)
  x1, y1 = from
  x2, y2 = to
  data[y1][x1] = '.'
  data[y2][x2] = '#'
end

def directions(direction)
  re = [0, 1, 2, 3]
  direction.times do
    re.push re.shift
  end
  re
end

def trim(data)
  ti = 0
  while true
    break if data[ti].count('#') > 0
    ti += 1
  end
  bi = 0
  while true
    break if data[data.size - 1 - bi].count('#') > 0
    bi += 1
  end
  li = 0
  while true
    break if data.map {|r| r[li]}.count('#') > 0
    li += 1
  end
  ri = 0
  while true
    break if data.map {|r| r[data.first.size - 1 - ri]}.count('#') > 0
    ri += 1
  end
  (ti + bi) * data.first.size + (li + ri) * data.size - (ti + bi) * 2
end

def calc(data)
  data.map {|r| r.count('.')}.sum - trim(data)
end

def adjust(data, proposed)
  prepend_y = proposed.select { |pt, pf| pt[1] < 0 }.size > 0
  prepend_x = proposed.select { |pt, pf| pt[0] < 0 }.size > 0
  append_y = proposed.select { |pt, pf| pt[1] > data.size - 1 }.size > 0
  append_x = proposed.select { |pt, pf| pt[0] > data.first.size - 1 }.size > 0
  if prepend_x || prepend_y
    proposed.each do |pt, pf|
      if prepend_x
        pt[0] += 1
        pf[0] += 1
      end
      if prepend_y
        pt[1] += 1
        pf[1] += 1
      end
    end
    prepend_row(data) if prepend_y
    prepend_column(data) if prepend_x
  end
  append_row(data) if append_y
  append_column(data) if append_x
end

def p1(data, round=100000)
  direction = 0

  round.times do |i|
    ds = directions(direction)
    proposed = {}
    data.each.with_index do |row, y|
      row.each_char.with_index do |c, x|
        next if c == '.'
        next if can_move_all?(data, [x, y])
        to = nil
        ds.each do |d|
          case d
          when 0
            to = [x, y-1] if north?(data, [x, y])
          when 1
            to = [x, y+1] if south?(data, [x, y])
          when 2
            to = [x-1, y] if west?(data, [x, y])
          when 3
            to = [x+1, y] if east?(data, [x, y])
          end
          break if to
        end
        next unless to

        if proposed[to]
          proposed[to] = 'no'
        else
          proposed[to] = [x, y]
        end
      end
    end

    proposed = proposed.select { |to, from| from != 'no' }
    return i + 1 if proposed.empty?
    adjust(data, proposed)
    proposed.each do |to, from|
      move(data, from, to)
    end
  
    # p "round #{i}"
    # data.each { |r| p r }
    direction += 1
    direction %= 4
  end

  calc(data)
end

# part 1
# with_time { p p1(data, 10) }
# part 2
with_time { p p1(data) }
