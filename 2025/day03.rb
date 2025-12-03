require './utils.rb'

data = get_input("03").map do |row|
  row.split('').map(&:to_i)
end

def p1(data)
  # binding.break
  data.inject(0) do |sum, row|
    sum + check(row)
  end
end

def check(row, m=2)
  result = []
  n = 0
  i = 0
  s = row.size
  while n < m
    j = s - m + n
    a = row[i..j]
    r = a.max
    i += a.index(r)+1
    result << r
    n += 1
  end
  result.join.to_i
end

def p2(data)
  data.inject(0) do |sum, row|
    sum + check(row, 12)
  end
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
