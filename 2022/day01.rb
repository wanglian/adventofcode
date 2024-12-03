data = File.open('input/day01.txt').readlines.map(&:chomp).map(&:to_i)

def p1(data)
  max = 0
  sum = 0
  data.each do |row|
    if row > 0
      sum += row
    else
      max = sum if sum > max
      sum = 0
    end
  end
  max = sum if sum > max
  max
end

def p2(data)
  max = [0, 0, 0]
  sum = 0
  data.each do |row|
    if row > 0
      sum += row
    else
      if sum > max.first
        max[0] = sum
        max.sort!
      end
      sum = 0
    end
  end
  max[0] = sum if sum > max.first
  max.sum
end

p p1(data)
p p2(data)
