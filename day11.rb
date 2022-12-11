require "ostruct"

data = File.open('input/day11.txt').readlines.map(&:chomp)

def parse(data)
  monkeys = []
  n = 0
  while n * 7 < data.length
    i = n * 7
    items       = data[i+1].scan(/\d+/).map(&:to_i)
    operation   = data[i+2].split(" = ").last
    test_number = data[i+3].scan(/\d+/).map(&:to_i).first
    test_true   = data[i+4].scan(/\d+/).map(&:to_i).first
    test_false  = data[i+5].scan(/\d+/).map(&:to_i).first
    monkeys << OpenStruct.new(
      items: items,
      operation: operation,
      test_number: test_number,
      test_true: test_true,
      test_false: test_false
    )
    n += 1
  end
  monkeys
end

def play(monkeys, round)
  inspected = monkeys.map { 0 }
  round.times do
    monkeys.each_with_index do |monkey, index|
      inspected[index] += monkey.items.size
      while old = monkey.items.shift
        item = eval monkey.operation
        item = yield(item)
        target = item % monkey.test_number == 0 ? monkey.test_true : monkey.test_false
        monkeys[target].items.push item
      end
    end
  end
  inspected.sort!
  inspected[-1] * inspected[-2]
end

# part 1
monkeys = parse(data)
p play(monkeys, 20) { |item| item / 3 }

# part 2
monkeys = parse(data)
lcm = monkeys.map { |m| m.test_number }.inject(1) { |re, n| re * n } # least common multiple
p play(monkeys, 10000) { |item| item % lcm }
