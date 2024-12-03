data = File.open('input/day02.txt').readlines.map(&:chomp).map { |r| r.split(' ') }

def p1(data)
  data.inject(0) do |sum, row|
    case row[0]
    when 'A'
      case row[1]
      when 'X'
        sum += (3 + 1)
      when 'Y'
        sum += (6 + 2)
      when 'Z'
        sum += (0 + 3)
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
        sum += (6 + 1)
      when 'Y'
        sum += (0 + 2)
      when 'Z'
        sum += (3 + 3)
      end
    end
    sum
  end
end

def p2(data)
  data.inject(0) do |sum, row|
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
    sum
  end
end

p p1(data)
p p2(data)
