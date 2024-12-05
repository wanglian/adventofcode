require './utils.rb'

data = get_input("14")

def p1(data)
  data = data.map {|row| row.split('')}
  # binding.break
  tilt_north(data)
  calc_load(data)
end

def tilt_north(data)
  data.each_with_index do |row, i|
    next if i == 0
    row.each_with_index do |r, j|
      move_north(data, i, j) if r == 'O'
    end
  end
end

def move_north(data, i, j)
  if i > 0 && data[i-1][j] == '.'
    data[i][j] = '.'
    data[i-1][j] = 'O'
    move_north(data, i-1, j)
  end
end

def calc_load(data)
  data.each_with_index.inject(0) do |sum, (row, i)|
    sum + row.count('O') * (data.size - i)
  end
end

def p2(data)
  data = data.map {|row| row.split('')}
  vs = []
  start = nil
  1000000000.times do |i|
    spin(data) 
    v = calc_value(data)
    # p "#{v} : #{re}"
    if k = vs.index(v)
      start = k
      break
    else
      vs << v
    end
  end
  n = (1000000000-start) % (vs.size-start) - 1
  n.times { spin(data) }
  calc_load(data)
end

def calc_value(data)
  Base64.encode64(data.map(&:join).join)
end

def spin(data)
  tilt_north(data)
  tilt_west(data)
  tilt_south(data)
  tilt_east(data)
end

def tilt_west(data)
  data.each_with_index do |row, i|
    row.each_with_index do |r, j|
      next if j == 0
      move_west(data, i, j) if r == 'O'
    end
  end
end

def move_west(data, i, j)
  if j > 0 && data[i][j-1] == '.'
    data[i][j] = '.'
    data[i][j-1] = 'O'
    move_west(data, i, j-1)
  end
end

def tilt_south(data)
  i = data.size - 2
  while i >= 0
    data[i].each_with_index do |r, j|
      move_south(data, i, j) if r == 'O'
    end
    i -= 1
  end
end

def move_south(data, i, j)
  if i < (data.size - 1) && data[i+1][j] == '.'
    data[i][j] = '.'
    data[i+1][j] = 'O'
    move_south(data, i+1, j)
  end
end

def tilt_east(data)
  data.each_with_index do |row, i|
    j = row.size - 2
    while j >= 0
      move_east(data, i, j) if row[j] == 'O'
      j -= 1
    end
  end
end

def move_east(data, i, j)
  if j < (data[0].size - 1) && data[i][j+1] == '.'
    data[i][j] = '.'
    data[i][j+1] = 'O'
    move_east(data, i, j+1)
  end
end

p p1(data)
p p2(data)
