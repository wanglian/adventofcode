data = File.open('day04.txt').readlines.map(&:chomp)
  .map { |r| r.split(',').map { |g| g.split('-').map(&:to_i) } }

def p1(data)
  data.inject(0) do |sum, row|
    (row[0][0] <= row[1][0] && row[0][1] >= row[1][1]) ||
    (row[0][0] >= row[1][0] && row[0][1] <= row[1][1]) ?
      sum + 1 : sum
  end
end

def p2(data)
  data.inject(0) do |sum, row|
    (row[0][0] <= row[1][0] && row[0][1] >= row[1][0]) ||
    (row[0][0] >= row[1][0] && row[0][0] <= row[1][1]) ?
      sum + 1 : sum
  end
end

p p1(data)
p p2(data)
