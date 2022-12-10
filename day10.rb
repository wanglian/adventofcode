data = File.open('input/day10.txt').readlines.map(&:chomp)
  .map { |row| row.split(' ') }

def execute(data, result)
  register = 1
  cycle = 0

  data.each do |row|
    case row[0]
    when 'noop'
      cycle += 1
      result += yield(cycle, register)
    when 'addx'
      cycle += 1
      result += yield(cycle, register)
      cycle += 1
      result += yield(cycle, register)
      register += row[1].to_i
    else
      raise "error: #{row}"
    end
  end

  result
end

def p1(data)
  execute(data, 0) do |cycle, register|
    if [20, 60, 100, 140, 180, 220].include?(cycle)
      cycle * register
    else
      0
    end
  end
end

def p2(data)
  result = execute(data, '') do |cycle, register|
    (cycle % 40 - 1 - register).abs > 1 ? '.' : '#'
  end
  result.scan(/.{40}/)
end

p p1(data)
p2(data).each { |row| p row }
