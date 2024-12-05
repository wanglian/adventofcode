require './utils.rb'

data = get_input("10").map {|row| row.split('')}

def p1(data)
  count = find_loop(data)
  (count+1) / 2
end

def find_start(data)
  data.each_with_index do |row, i|
    row.each_with_index do |pipe, j|
      return [i, j] if pipe == 'S'
    end
  end
end

def find_loop(data)
  x, y = find_start(data)
  # p [x, y]
  if x > 0 && %w(| 7 F).include?(data[x-1][y])
    re = forward(data, x-1, y, 'up')
    return re if re
  end
  if x < (data.size-1) && %w(| L J).include?(data[x+1][y])
    re = forward(data, x+1, y, 'down')
    return re if re
  end
  if y > 0 && %w(- L F).include?(data[x][y-1])
    re = forward(data, x, y-1, 'left')
    return re if re
  end
  if y < (data[0].size-1) && %w(- 7 J).include?(data[x][y+1])
    re = forward(data, x, y+1, 'right')
    return re if re
  end
end

def forward(data, x, y, from)
  count = 1
  while true
    return false if x < 0 || x >= data.size || y < 0 || y >= data[0].size || data[x][y] == '.'
    # p "#{[x, y]} - #{from} - #{data[x][y]} - #{count}"
    case data[x][y]
    when '|'
      x = from == 'up' ? x-1 : x+1
    when '-'
      y = from == 'left' ? y-1 : y+1
    when 'L'
      if from == 'down'
        y += 1
        from = 'right'
      else
        x -= 1
        from = 'up'
      end
    when 'J'
      if from == 'down'
        y -= 1
        from = 'left'
      else
        x -= 1
        from = 'up'
      end
    when '7'
      if from == 'right'
        x += 1
        from = 'down'
      else
        y -= 1
        from = 'left'
      end
    when 'F'
      if from == 'up'
        y += 1
        from = 'right'
      else
        x += 1
        from = 'down'
      end
    when 'S'
      return count
    end
    count += 1
  end
end

# https://en.wikipedia.org/wiki/Point_in_polygon
def p2(data)
  new_data = Array.new data.size
  data.each_with_index {|s, i| new_data[i] = Array.new(data[0].size, '.') }
  find_loop2(data, new_data)
  # inside? data, 4, 11
  new_data[96][101] = 'L' # to improve: update start
  result = 0
  data.each_with_index do |row, x|
    row.each_with_index do |c, y|
      next if PIPES.include?(new_data[x][y])
      if inside?(new_data, x, y)
        result += 1
        new_data[x][y] = 'I'
        # p [x, y]
      else
        new_data[x][y] = 'O'
      end
    end
  end
  # data.each {|row| p row.join}
  # p ''
  new_data.each {|row| p row.join}
  result
end

PIPES = %w(| - L J 7 F S)
def inside?(data, x, y)
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
  (count % 2) == 1
end

def connected?(data, x, y)
  data[x-1][y] == '*' || data[x+1][y] == '*' || data[x][y-1] == '*' || data[x][y+1] == '*'
end

def find_loop2(data, new_data)
  x, y = find_start(data)
  p [x, y]
  if x > 0 && %w(| 7 F).include?(data[x-1][y])
    re = forward2(data, x-1, y, 'up', new_data)
    return re if re
  end
  if x < (data.size-1) && %w(| L J).include?(data[x+1][y])
    re = forward2(data, x+1, y, 'down', new_data)
    return re if re
  end
  if y > 0 && %w(- L F).include?(data[x][y-1])
    re = forward2(data, x, y-1, 'left', new_data)
    return re if re
  end
  if y < (data[0].size-1) && %w(- 7 J).include?(data[x][y+1])
    re = forward2(data, x, y+1, 'right', new_data)
    return re if re
  end
end

def forward2(data, x, y, from, new_data)
  count = 1
  while true
    return false if x < 0 || x >= data.size || y < 0 || y >= data[0].size || data[x][y] == '.'
    # p "#{[x, y]} - #{from} - #{data[x][y]} - #{count}"
    v = data[x][y]
    new_data[x][y] = v
    # data[x][y] = '.'
    case v
    when '|'
      x = from == 'up' ? x-1 : x+1
    when '-'
      y = from == 'left' ? y-1 : y+1
    when 'L'
      if from == 'down'
        y += 1
        from = 'right'
      else
        x -= 1
        from = 'up'
      end
    when 'J'
      if from == 'down'
        y -= 1
        from = 'left'
      else
        x -= 1
        from = 'up'
      end
    when '7'
      if from == 'right'
        x += 1
        from = 'down'
      else
        y -= 1
        from = 'left'
      end
    when 'F'
      if from == 'up'
        y += 1
        from = 'right'
      else
        x += 1
        from = 'down'
      end
    when 'S'
      return count
    end
    count += 1
  end
end

p p1(data)
p p2(data)
