require './utils.rb'

data = get_input("20")

def mix(data, index)
  size = data.size
  size.times do |i|
    j = index.index(i)
    n = data[j]
    if n > 0
      data.delete_at(j)
      k = (j + n) % data.size
      data.insert(k, n)
      index.delete_at(j)
      index.insert(k, i)
    elsif n < 0
      data.delete_at(j)
      k = (j + n) % data.size 
      k = data.size if k == 0
      data.insert(k, n)
      index.delete_at(j)
      index.insert(k, i)
    end
  end
end

def calc(data)
  i = data.index(0)
  size = data.size
  data[(i+1000)%size] + data[(i+2000)%size] + data[(i+3000)%size]
end

def p1(data)
  data = data.map(&:to_i)
  index = (0..(data.length-1)).to_a
  mix(data, index)
  calc(data)
end

def p2(data)
  data = data.map(&:to_i)
  index = (0..(data.length-1)).to_a
  data.each_with_index do |d, i|
    data[i] *= 811589153
  end
  10.times do
    mix(data, index)
  end
  calc(data)
end

# part 1
with_time { p p1(data) }
# part 2
with_time { p p2(data) }
