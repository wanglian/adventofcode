data = File.open('input/day05.txt').readlines.map(&:chomp)

def parse_stacks(data)
  stacks = []
  n = 0
  while data[n][1, 1] != '1'
    ## [Z] [M] [P]
    # regex
    matches = data[n].to_enum(:scan, /[[A-Z]]/).map { Regexp.last_match }
    matches.each do |match|
      pos = match.begin(0)/4 + 1 # start from 1
      stacks[pos] ||= []
      stacks[pos].unshift match.to_s
    end
    # manual match
    # i = 0
    # while (k = (1 + i*4)) < data[n].length
    #   c = data[n][k, 1]
    #   unless c == ' '
    #     stacks[i+1] ||= [] # start from 1
    #     stacks[i+1].unshift data[n][k, 1]
    #   end
    #   i += 1
    # end
    n += 1
  end

  [stacks, n + 2] # stacks, and cursor of operations
end

def parse_operation(row)
  ## move 1 from 2 to 1
  row.scan(/\d+/).map(&:to_i)
end

def peek(stacks)
  stacks.inject("") do |sum, stack|
    sum += stack.last if stack&.last
    sum
  end
end

def p1(data)
  stacks, n = parse_stacks(data)
  while n < data.length
    count, from, to = parse_operation(data[n])
    count.times { stacks[to].push(stacks[from].pop) }
    n += 1
  end

  peek(stacks)
end

def p2(data)
  stacks, n = parse_stacks(data)
  while n < data.length
    count, from, to = parse_operation(data[n])
    tmp = []
    count.times { tmp.push(stacks[from].pop) }
    count.times { stacks[to].push(tmp.pop) }
    n += 1
  end

  peek(stacks)
end

p p1(data)
p p2(data)
