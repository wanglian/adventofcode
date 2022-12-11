require "ostruct"

data = File.open('input/day11.txt').readlines.map(&:chomp)

def parse(data)
  # [
  #   OpenStruct.new(items: [79, 98],         operation: "item * 19",   test: [23, [2, 3]]),
  #   OpenStruct.new(items: [54, 65, 75, 74], operation: "item + 6",    test: [19, [2, 0]]),
  #   OpenStruct.new(items: [79, 60, 97],     operation: "item * item", test: [13, [1, 3]]),
  #   OpenStruct.new(items: [74],             operation: "item + 3",    test: [17, [0, 1]])
  # ]
  # [
  #   OpenStruct.new(items: [97, 81, 57, 57, 91, 61],         operation: "item * 7", test: [11, [5, 6]]),
  #   OpenStruct.new(items: [88, 62, 68, 90],                 operation: "item * 17", test: [19, [4, 2]]),
  #   OpenStruct.new(items: [74, 87],                         operation: "item + 2", test: [5, [7, 4]]),
  #   OpenStruct.new(items: [53, 81, 60, 87, 90, 99, 75],     operation: "item + 1", test: [2, [2, 1]]),
  #   OpenStruct.new(items: [57],                             operation: "item + 6", test: [13, [7, 0]]),
  #   OpenStruct.new(items: [54, 84, 91, 55, 59, 72, 75, 70], operation: "item * item", test: [7, [6, 3]]),
  #   OpenStruct.new(items: [95, 79, 79, 68, 78],             operation: "item + 3", test: [3, [1, 3]]),
  #   OpenStruct.new(items: [61, 97, 67],                     operation: "item + 4", test: [17, [0, 5]]),
  # ]
  monkeys = []
  n = 0
  while n * 7 < data.length
    i = n * 7
    items      = data[i+1].scan(/\d+/).map(&:to_i)
    operation  = data[i+2].split(" = ").last
    test_num   = data[i+3].scan(/\d+/).map(&:to_i).first
    test_true  = data[i+4].scan(/\d+/).map(&:to_i).first
    test_false = data[i+5].scan(/\d+/).map(&:to_i).first
    monkeys << OpenStruct.new(items: items, operation: operation, test: [test_num, [test_true, test_false]])
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
        target = item % monkey.test[0] == 0 ? monkey.test[1].first : monkey.test[1].last
        monkeys[target].items.push item
      end
    end
  end
  inspected.sort!
  inspected[-1] * inspected[-2]
end

monkeys = parse(data)
p play(monkeys, 20) { |item| item / 3 }

monkeys = parse(data)
max = monkeys.map { |m| m.test[0] }.inject(1) { |re, n| re * n } # least common multiple
p play(monkeys, 10000) { |item| item % max }
