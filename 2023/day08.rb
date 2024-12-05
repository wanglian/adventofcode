require './utils.rb'

data = get_input("08")

def p1(data)
  instructions = nil
  networks = {}
  data.each_with_index do |row, i|
    next if row.empty?
    if i == 0
      instructions = row.split('')
    else
      tmp = row.split(" = ")
      networks[tmp[0]] = tmp[1][1, tmp[1].size-2].split(', ')
    end
  end
  
  i = 0
  current = 'AAA'
  while true
    instruction = instructions[i%instructions.size]
    case instruction
    when 'L'
      current = networks[current][0]
    when 'R'
      current = networks[current][1]
    else
      raise "WTF #{instruction}"
    end
    i += 1
    break if current == 'ZZZ'
  end
  i
rescue
  "that's ok"
end

def p2(data)
  instructions = nil
  networks = {}
  currents = []
  data.each_with_index do |row, i|
    next if row.empty?
    if i == 0
      instructions = row.split('')
    else
      tmp = row.split(" = ")
      networks[tmp[0]] = tmp[1][1, tmp[1].size-2].split(', ')
      currents << tmp[0] if tmp[0][-1] == 'A'
    end
  end
  
  currents.collect do |current|
    i = 0
    while true
      instruction = instructions[i%instructions.size]
      case instruction
      when 'L'
        current = networks[current][0]
      when 'R'
        current = networks[current][1]
      else
        raise "WTF #{instruction}"
      end
      i += 1
      break if current[-1] == 'Z'
    end
    i
  end.inject(1) do |re, s|
    re.lcm(s)
  end
end

p p1(data)
p p2(data)
