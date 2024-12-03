require './utils.rb'

data = get_input("25")
# p data

def map(c)
  case c
  when '-'
    -1
  when '='
    -2
  else
    c.to_i
  end
end

def convert10(s)
  f = s.split('')
  re = 0
  i = 0
  while f.size > 0
    c = f.pop
    re += map(c) * 5**i
    i += 1
  end
  re
end

def dmap(i)
  case i
  when -1
    '-'
  when -2
    '='
  else
    i.to_s
  end
end

def convert5(n)
  re = []
  while 
    d = n / 5
    r = n % 5
    if r > 2
      d += 1
      r -= 5
    end
    re.unshift dmap(r)
    break if d == 0
    n = d
  end
  re.join
end

def p1(data)
  sum = data.map { |r| convert10(r) }.sum
  convert5(sum)
end

# part 1
with_time { p p1(data) }
