require './utils.rb'

data = get_input("06")

def p1(data)
  times = data[0].scan(/\d+/).map(&:to_i)
  distances = data[1].scan(/\d+/).map(&:to_i)

  times.each_with_index.inject(1) do |result, (time, i)|
    min = 0
    max = time / 2
    while min < max
      tmp = (min + max) / 2
      break if tmp == min
      d = calc_distance(time, tmp)
      if d > distances[i]
        max = tmp
      else
        min = tmp
      end
    end
    ways = time - max * 2 + 1
    result * ways
  end
end

def calc_distance(time, start)
  start * (time - start)
end

def p2(data)
  time = data[0].scan(/\d+/).join.to_i
  distance = data[1].scan(/\d+/).join.to_i

  min = 0
  max = time / 2
  while min < max
    tmp = (min + max) / 2
    break if tmp == min
    d = calc_distance(time, tmp)
    if d > distance
      max = tmp
    else
      min = tmp
    end
  end
  time - max * 2 + 1
end

p p1(data)
p p2(data)
