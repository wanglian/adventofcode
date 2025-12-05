require './utils.rb'

data = get_input("05")
i = data.index("")
@ranges = data[..(i-1)].map do |r|
  min, max = r.split('-').map(&:to_i)
  min..max
end.sort do |a, b|
  if a.min == b.min
    a.max <=> b.max
  else
    a.min <=> b.min
  end
end
@ids = data[(i+1)..].map(&:to_i)

def fresh?(id)
  @ranges.each do |range|
    return true if range.include?(id)
  end
  false
end

def p1(data)
  # binding.break
  @ids.count { |id| fresh?(id) }
end

def can_merge?(r1, r2)
  r1.max >= (r2.min - 1)
end

def merge(r1, r2)
  (r1.min)..([r1.max, r2.max].max)
end

def p2(data)
  i = 0
  result = []
  r1 = @ranges[i]
  while i < (@ranges.size - 1)
    r2 = @ranges[i+1]
    r1 = if can_merge?(r1, r2)
      merge(r1, r2)
    else
      result << r1
      r2
    end
    i += 1
  end
  result << r1
  result.sum { |r| r.size }
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
