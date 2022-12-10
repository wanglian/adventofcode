data = File.open('input/day10.txt').readlines.map(&:chomp)
  .map { |row| row.split(' ') }

def check(cycle, register)
  # p "#{cycle}: #{register}"
  if [20, 60, 100, 140, 180, 220].include?(cycle)
    cycle * register
  else
    0
  end
end

def p1(data)
  register = 1
  cycle = 0
  result = 0

  data.each do |row|
    case row[0]
    when 'noop'
      cycle += 1
      result += check(cycle, register)
    when 'addx'
      cycle += 1
      result += check(cycle, register)
      cycle += 1
      result += check(cycle, register)
      register += row[1].to_i
    else
      raise "error: #{row}"
    end
  end

  result
end

def draw(cycle, register)
  (cycle % 40 - 1 - register).abs > 1 ? '.' : '#'
end

def p2(data)
  register = 1 # pos
  cycle = 0 # draw
  result = ""

  data.each do |row|
    case row[0]
    when 'noop'
      cycle += 1
      result += draw(cycle, register)
    when 'addx'
      cycle += 1
      result += draw(cycle, register)
      cycle += 1
      result += draw(cycle, register)
      register += row[1].to_i
    else
      raise "error: #{row}"
    end
  end

  result.scan(/.{40}/).each { |row| p row }
end

p p1(data)
p2(data)
