require './utils.rb'

data = get_input("16").map {|row| row.split('')}

def p1(data)
  energy(data, [0, 0], 'right')
end

def energy(data, start, direction)
  traced = {}
  path = []
  steps = [[start, direction]]
  while steps.size > 0
    tmp = []
    steps.each do |step|
      pos, direction = step
      traced["#{pos[0]}-#{pos[1]}-#{direction}"] = true
      path[pos[0]] ||= []
      path[pos[0]][pos[1]] = '#'
      # p step
      next_tiles(data, pos, direction).each do |t|
        tmp << t unless traced["#{t[0][0]}-#{t[0][1]}-#{t[1]}"]
      end
    end
    steps = tmp
  end
  # binding.break
  path.inject(0) do |sum, row|
    if row
      sum + row.count('#')
    else
      sum
    end
  end
end

def next_tiles(data, pos, direction)
  result = []
  x, y = pos
  case direction
  when 'right'
    case data[x][y]
    when '.', '-'
      result << [[x, y+1], 'right'] if y < (data[0].size-1)
    when '|'
      result << [[x-1, y], 'up'] if x > 0
      result << [[x+1, y], 'down'] if x < (data.size-1)
    when '/'
      result << [[x-1, y], 'up'] if x > 0
    when '\\'
      result << [[x+1, y], 'down'] if x < (data.size-1)
    end
  when 'down'
    case data[x][y]
    when '.', '|'
      result << [[x+1, y], 'down'] if x < (data.size-1)
    when '-'
      result << [[x, y-1], 'left'] if y > 0
      result << [[x, y+1], 'right'] if y < (data[0].size-1)
    when '/'
      result << [[x, y-1], 'left'] if y > 0
    when '\\'
      result << [[x, y+1], 'right'] if y < (data[0].size-1)
    end
  when 'left'
    case data[x][y]
    when '.', '-'
      result << [[x, y-1], 'left'] if y > 0
    when '|'
      result << [[x-1, y], 'up'] if x > 0
      result << [[x+1, y], 'down'] if x < (data.size-1)
    when '/'
      result << [[x+1, y], 'down'] if x < (data.size-1)
    when '\\'
      result << [[x-1, y], 'up'] if x > 0
    end
  when 'up'
    case data[x][y]
    when '.', '|'
      result << [[x-1, y], 'up'] if x > 0
    when '-'
      result << [[x, y-1], 'left'] if y > 0
      result << [[x, y+1], 'right'] if y < (data[0].size-1)
    when '/'
      result << [[x, y+1], 'right'] if y < (data[0].size-1)
    when '\\'
      result << [[x, y-1], 'left'] if y > 0
    end
  end
  result
end

def p2(data)
  result = 0
  data.first.each_index do |i|
    e = energy(data, [0, i], 'down')
    result = e if e > result
  end
  data.last.each_index do |i|
    e = energy(data, [data.size-1, i], 'up')
    result = e if e > result
  end
  data.each_index do |i|
    e = energy(data, [i, 0], 'right')
    result = e if e > result
    e = energy(data, [i, data[0].size-1], 'left')
    result = e if e > result
  end
  result
end

p p1(data)
p p2(data)
