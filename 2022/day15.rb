data = File.open('input/day15.txt').readlines.map(&:chomp)
  .map do |row|
    row.split(':').map do |s|
      s.scan(/-*\d+/).map(&:to_i)
    end
  end

def manhattan_distance(p1, p2)
  (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
end

def range(sensor, y)
  k = sensor[2] - (y-sensor[0][1]).abs
  return nil if k < 0
  [sensor[0][0] - k, sensor[0][0] + k]
end

def parse(data, y)
  data.each do |sensor|
    sensor[2] = manhattan_distance(sensor[0], sensor[1])
    sensor[3] = range(sensor, y)
  end
end

def count(range)
  range[1] - range[0] + 1
end

def merge(ranges)
  result = []
  
  i = 0
  while i < ranges.length - 1
    r = ranges[i]
    tmp = [r[0], r[1]]
    i += 1
    while i < ranges.length
      if tmp[1] < ranges[i][0]
        result << tmp
        break
      else
        tmp[1] = ranges[i][1] if ranges[i][1] > tmp[1]
        i += 1
      end
    end
  end
  result << tmp
  result
end

def p1(data, y)
  parse(data, y)
  ranges = data.map { |sensor| sensor[3] }.compact.sort
  result = merge(ranges)
  result.map { |r| count(r) }.sum
end

def calc(point)
  p point
  4000000 * point[0] + point[1]
end

def p2(data, max)
  i = 0
  result = nil
  while i <= max
    parse(data, i)
    ranges = data.map { |sensor| sensor[3] }.compact.sort
    result = merge(ranges)
    break if result.size > 1
    i += 1
  end
  calc([result[0][1] + 1, i])
end

# p p1(data, 10) # test
p p1(data, 2000000)
# p p2(data, 20) # test
p p2(data, 4000000)
