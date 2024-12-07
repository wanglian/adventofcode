require './utils.rb'

data = get_input("06").map { |row| row.split('') }

def p1(data)
  # binding.break
  visited = traverse(data)
  visited.count
end

def traverse(data, visited={}, start=nil)
  start ||= start_position(data)
  mx, my = data.size-1, data[0].size-1
  x, y, v = start
  while true
    raise "LOOP #{[x, y]}" if visited[[x,y]]&.include?(v)
    visit(visited, x, y, v)

    case v
    when '^'
      break if x == 0

      if data[x-1][y] == '#'
        break if y == my
        if data[x][y+1] == '#'
          v = 'v'
        else
          v = '>'
          y += 1
        end
      else
        x -= 1
      end
    when '>'
      break if y == my

      if data[x][y+1] == '#'
        break if x == mx
        if data[x+1][y] == '#'
          v = '<'
        else
          v = 'v'
          x += 1
        end
      else
        y += 1
      end
    when '<'
      break if y == 0

      if data[x][y-1] == '#'
        break if x == 0
        if data[x-1][y] == '#'
          v = '>'
        else
          v = '^'
          x -= 1
        end
      else
        y -= 1
      end
    when 'v'
      break if x == mx

      if data[x+1][y] == '#'
        break if y == 0
        if data[x][y-1] == '#'
          v = '^'
        else
          v = '<'
          y -= 1
        end
      else
        x += 1
      end
    else
      railse "!!! #{v}"
    end
  end
  visited
end

def start_position(data)
  data.each_with_index do |row, i|
    row.each_with_index do |v, j|
      return [i, j, v] if %w(^ v > <).include?(v)
    end
  end
end

def visit(visited, x, y, v)
  visited[[x,y]] ||= []
  visited[[x,y]] << v
end

def p2(data)
  x0, y0, v0 = start_position(data)

  visited = traverse(data)

  visited = visited.keys

  result = []
  visited.each do |pos|
    x, y = pos
    next if data[x][y] == v0

    data[x][y] = '#'
    begin
      traverse(data)
    rescue => e
      result << pos
    end
    data[x][y] = '.'
  end

  result.count
end

p p1(data)
with_time { p p2(data) }
