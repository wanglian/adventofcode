require './utils.rb'

data = get_input("25")

def parse(data)
  locks, keys = [], []
  grid = []
  data.each do |row|
    if row.empty?
      if grid[0][0] == '#'
        locks << parse_lock(grid)
      else
        keys << parse_lock(grid)
      end
      grid = []
    else
      grid << row.split('')
    end
  end
  if grid[0][0] == '#'
    locks << parse_lock(grid)
  else
    keys << parse_lock(grid)
  end

  [locks, keys]
end

def parse_lock(grid)
  5.times.map do |i|
    5.times.inject(0) do |sum, j|
      sum + (grid[j+1][i] == '#' ? 1 : 0)
    end
  end
end

def match?(lock, key)
  5.times do |i|
    return false if (lock[i] + key[i]) > 5
  end
  true
end

def p1(data)
  locks, keys = parse(data)
  locks.inject(0) do |sum, lock|
    sum + keys.inject(0) do |ssum, key|
      ssum + (match?(lock, key) ? 1 : 0)
    end
  end
end

def p2(data)
  "Merry Christmas!!!"
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
