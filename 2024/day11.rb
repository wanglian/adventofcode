require './utils.rb'

data = get_input("11")[0].split(" ") #.map(&:to_i)

def p1(data, times=25)
  # binding.break
  times.times do
    data = blink(data)
  end
  data.size
end

def blink(data)
  new_data = []
  data.each do |n|
    if n == '0'
      new_data << '1'
    elsif n.size % 2 == 0
      size = n.size/2
      new_data << n[0, size]
      new_data << n[size, size].to_i.to_s
    else
      new_data << (n.to_i * 2024).to_s
    end
  end
  new_data
end

def p2(data)
  data.inject(0) { |sum, d| sum + blink2(d, 75) }
end

@cache = {}
def blink2(n, k)
  return @cache[[n, k]] if @cache[[n, k]]
  re = if n == '0'
    return 1 if k == 1
    blink2('1', k-1)
  elsif n.size % 2 == 0
    return 2 if k == 1
    size = n.size/2
    blink2(n[0, size], k-1) + blink2(n[size, size].to_i.to_s, k-1)
  else
    return 1 if k == 1
    blink2((n.to_i * 2024).to_s, k-1)
  end
  @cache[[n, k]] = re
  re
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
