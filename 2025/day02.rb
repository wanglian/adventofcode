require './utils.rb'

data = get_input("02")[0].split(',').map { |r| r.split('-').map(&:to_i)}

def check(range)
  min, max = range
  (min..max).inject(0) do |sum, n|
    is_invalid = invalid?(n)
    sum + (is_invalid ? n : 0)
  end
end

def invalid?(n)
  s = n.to_s
  size = s.size
  return false if size % 2 == 1

  h = size / 2
  s[0, h] == s[h, h]
end

def check2(range)
  min, max = range
  (min..max).inject(0) do |sum, n|
    is_invalid = invalid2?(n)
    sum + (is_invalid ? n : 0)
  end
end

# TODO: improve performance
def invalid2?(n)
  s = n.to_s
  size = s.size
  k = size / 2

  (1..k).each do |i|
    return true if repeat_n?(s, i)
  end
  false
end

def repeat_n?(s, n)
  return false unless s.size % n == 0

  s.scan(/.{1,#{n}}/).uniq.size == 1
end

def p1(data)
  # binding.break
  data.inject(0) do |sum, range|
    sum + check(range)
  end
end

def p2(data)
  data.inject(0) do |sum, range|
    sum + check2(range)
  end
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
