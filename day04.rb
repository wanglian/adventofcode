file = File.open 'day04.txt'
data = file.readlines.map(&:chomp).map { |r| r.split(',').map { |g| g.split('-').map(&:to_i) } }

def p1(data)
  re = 0
  data.each do |row|
    if (row[0][0] <= row[1][0] && row[0][1] >= row[1][1]) ||
       (row[0][0] >= row[1][0] && row[0][1] <= row[1][1])
      re += 1
    end
  end
  re
end

def p2(data)
  re = 0
  data.each do |row|
    if (row[0][0] <= row[1][0] && row[0][1] >= row[1][0]) ||
       (row[0][0] >= row[1][0] && row[0][0] <= row[1][1])
      re += 1
    end
  end
  re
end

p p1(data)
p p2(data)
