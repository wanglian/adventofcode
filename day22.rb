require './utils.rb'

data = get_input("22")

path = data.pop.scan /\d+|L|R/
data.pop

# p data
# p path

def find_start(data, y)
  data[y].size.times { |x| return x if data[y][x] && data[y][x] != ' ' }
end

def find_end(data, y)
  size = data[y].size
  size.times do |i|
    x = (size - i) % size
    return x if data[y][x] && data[y][x] != ' '
  end
end

def find_start_y(data, x)
  data.size.times { |y| return y if data[y][x] && data[y][x] != ' ' }
end

def find_end_y(data, x)
  size = data.size
  size.times do |i|
    y = (size - i - 1) % size
    return y if data[y][x] && data[y][x] != ' '
  end
end

def turn(facing, d)
  if d == 'L'
    (facing - 1) % 4
  else
    (facing + 1) % 4
  end
end

def move_right(data, from, steps)
  x, y = from
  steps.times do |i|
    data[y][x] = '>' #if data[y][x] == '.'
    j = x + 1
    j %= data[y].size
    if data[y][j].nil? || data[y][j] == ' '
      j = find_start(data, y)
    end

    if data[y][j] == '#'
      return x
    else
      x = j
    end
  end
  x
end

def move_left(data, from, steps)
  x, y = from
  steps.times do |i|
    data[y][x] = '<' #if data[y][x] == '.'
    j = x - 1
    j %= data[y].size
    if data[y][j].nil? || data[y][j] == ' '
      j = find_end(data, y)
    end

    if data[y][j] == '#'
      return x
    else
      x = j
    end
  end
  x
end

def move_down(data, from, steps)
  x, y = from
  steps.times do |i|
    data[y][x] = 'v' #if data[y][x] == '.'
    j = y + 1
    j %= data.size
    if data[j][x].nil? || data[j][x] == ' '
      j = find_start_y(data, x)
    end

    if data[j][x] == '#'
      return y
    else
      y = j
    end
  end
  y
end

def move_up(data, from, steps)
  x, y = from
  steps.times do |i|
    data[y][x] = '^' #if data[y][x] == '.'
    j = y - 1
    j %= data.size
    if data[j][x].nil? || data[j][x] == ' '
      j = find_end_y(data, x)
    end

    if data[j][x] == '#'
      return y
    else
      y = j
    end
  end
  y
end

def move(data, from, facing, steps)
  x, y = from
  case facing
  when 0
    x = move_right(data, [x, y], steps)
  when 1
    y = move_down(data, [x, y], steps)
  when 2
    x = move_left(data, [x, y], steps)
  when 3
    y = move_up(data, [x, y], steps)
  else
    raise 'adfsd'
  end
  [x, y, facing]
end

def move2(data, from, facing, steps)
  x, y = from
  edge = data.first.size / 3
  steps.times do |i|
    xj, yj, fj =
      case facing
      when 0
        data[y][x] = '>'
        xj, yj = x + 1, y
        if data[yj][xj].nil? || data[yj][xj] == ' '
          if yj < edge
            [data.last.size - 1, data.size - yj - 1, 2]
          elsif yj < edge * 2
            [xj + edge * 2 - yj - 1, edge * 2, 1]
          else
            [edge * 3 - 1, edge * 3 - yj - 1, 2]
          end
        else
          [xj, yj, facing]
        end
      when 1
        data[y][x] = 'v'
        xj, yj = x, y + 1
        if yj == data.size || data[yj][xj].nil? || data[yj][xj] == ' '
          if xj < edge
            [edge * 3 - xj - 1, edge * 3 - 1, 3]
          elsif xj < edge * 2
            [edge * 2, edge * 4 - xj, 0]
          elsif xj < edge * 3
            [edge * 3 - xj - 1, edge * 2 - 1, 3]
          else
            [0, edge * 5 - xj, 0]
          end
        else
          [xj, yj, facing]
        end
      when 2
        data[y][x] = '<'
        xj, yj = x - 1, y
        if data[yj][xj].nil? || data[yj][xj] == ' '
          if yj < edge
            [edge + yj, edge, 1]
          elsif xj < edge * 2
            [edge * 5 - yj, edge * 3 - 1, 3]
          else
            [edge * 4 - yj - 1, edge * 2 - 1, 3]
          end
        else
          [xj, yj, facing]
        end
      when 3
        data[y][x] = '^' - 1
        if yj < 0 || data[yj][xj].nil? || data[yj][xj] == ' '
          if xj < edge
            [edge * 3 - xj - 1, 0, 1]
          elsif xj < edge * 2
            [edge * 2, xj - edge, 0]
          elsif xj < edge * 3
            [edge * 3 - yj - 1, edge - 1, 1]
          else
            [edge * 3 - 1, edge * 5 - xj - 1, 2]
          end
        else
          [xj, yj, facing]
        end
      end

    if data[yj][xj] == '#'
      return [x, y, facing]
    else
      x, y, facing = [xj, yj, fj]
    end
  end
  [x, y, facing]
end

def move3(data, from, facing, steps)
  x, y = from
  edge = data.first.size / 3
  p edge
  steps.times do |i|
    p [x, y, facing]
    xj, yj, fj =
      case facing
      when 0
        data[y][x] = '>'
        xj, yj = x + 1, y
        if data[yj][xj].nil? || data[yj][xj] == ' '
          if yj < edge
            [edge * 2 - 1, edge * 3 - yj - 1, 2]
          elsif yj < edge * 2
            [edge + yj, edge - 1, 3]
          elsif yj < edge * 3
            [edge * 3 - 1, edge * 3 - yj - 1, 2]
          else
            [yj - edge * 2, edge * 3 - 1, 3]
          end
        else
          [xj, yj, facing]
        end
      when 1
        data[y][x] = 'v'
        xj, yj = x, y + 1
        if yj == data.size || data[yj][xj].nil? || data[yj][xj] == ' '
          if xj < edge
            [edge * 2 + xj, 0, 1]
          elsif xj < edge * 2
            [edge - 1, edge * 2 + xj, 2]
          else
            [edge * 2 - 1, xj - edge, 2]
          end
        else
          [xj, yj, facing]
        end
      when 2
        data[y][x] = '<'
        xj, yj = x - 1, y
        if xj < 0 || data[yj][xj].nil? || data[yj][xj] == ' '
          if yj < edge
            [0, edge * 3 - yj - 1, 0]
          elsif yj < edge * 2
            [yj - edge, edge * 2, 1]
          elsif yj < edge * 3
            [edge, edge * 3 - yj - 1, 0]
          else
            [yj - edge * 2, 0, 1]
          end
        else
          [xj, yj, facing]
        end
      when 3
        data[y][x] = '^'
        xj, yj = x, y - 1
        if yj < 0 || data[yj][xj].nil? || data[yj][xj] == ' '
          if xj < edge
            [edge, edge + xj, 0]
          elsif xj < edge * 2
            [0, xj + edge * 2, 0]
          else
            [xj - edge * 2, edge * 4 - 1, 3]
          end
        else
          [xj, yj, facing]
        end
      end

    if data[yj][xj] == '#'
      return [x, y, facing]
    else
      x, y, facing = [xj, yj, fj]
    end
  end
  [x, y, facing]
end

def result(x, y, facing)
  (y + 1) * 1000 + (x + 1) * 4 + facing
end

def traverse(data, path)
  x = find_start(data, 0)
  y = 0
  facing = 0
  data[y][x] = 'S'
  path.each do |s|
    case s
    when 'L', 'R'
      facing = turn(facing, s)
    else
      x, y, facing = yield(data, [x, y], facing, s.to_i)
    end
  end
  data[y][x] = 'E'

  # data.each { |r| p r }
  result(x, y, facing)
end

# part 1
with_time { p traverse(data, path) { |data, from, facing, steps| move(data, from, facing, steps) }  }
# part 2 example
# with_time { p traverse(data, path) { |data, from, facing, steps| move2(data, from, facing, steps) } }
# part 2
# with_time { p traverse(data, path) { |data, from, facing, steps| move3(data, from, facing, steps) } }
