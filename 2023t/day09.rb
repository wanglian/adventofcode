require './utils.rb'

data = get_input("09")

def p1(data)
  data.inject(0) do |sum, row|
    data = row.strip.split(' ').map(&:to_i)
    re = 0
    while true
      re += data.last
      tmp = (0..(data.length-2)).map do |i|
        data[i+1] - data[i]
      end
      break if tmp.uniq.size == 1 && tmp.first == 0
      data = tmp
    end
    sum + re
  end
end

def p2(data)
  data.inject(0) do |sum, row|
    data = row.strip.split(' ').map(&:to_i)
    re = data.first
    sign = -1
    while true
      tmp = (0..(data.length-2)).map do |i|
        data[i+1] - data[i]
      end
      re += tmp.first * sign
      sign *= -1
      break if tmp.uniq.size == 1 && tmp.first == 0
      data = tmp
    end
    sum + re
  end
end

p p1(data)
p p2(data)
