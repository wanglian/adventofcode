file = File.open 'input.txt'
data = file.readlines.map(&:chomp).map { |r| r.split(' ') }

sum = 0
data.each do |row|
  case row[0]
  when 'A'
    case row[1]
    when 'X'
      sum += (0 + 3)
    when 'Y'
      sum += (3 + 1)
    when 'Z'
      sum += (6 + 2)
    end
  when 'B'
    case row[1]
    when 'X'
      sum += (0 + 1)
    when 'Y'
      sum += (3 + 2)
    when 'Z'
      sum += (6 + 3)
    end
  when 'C'
    case row[1]
    when 'X'
      sum += (0 + 2)
    when 'Y'
      sum += (3 + 3)
    when 'Z'
      sum += (6 + 1)
    end
  end
end

p sum
