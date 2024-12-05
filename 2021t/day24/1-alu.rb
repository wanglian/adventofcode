file = File.open 'input.txt'

data = [
  'inp x',
  'mul x -1',
]

data = [
  'inp z',
  'inp x',
  'mul z 3',
  'eql z x',
]

data = [
  'inp w',
  'add z w',
  'mod z 2',
  'div w 2',
  'add y w',
  'mod y 2',
  'div w 2',
  'add x w',
  'mod x 2',
  'div w 2',
  'mod w 2',
]

data = file.readlines.map(&:chomp)

instructions = data.map {|row| row.split(' ')}

@batches = []
tmp = []
i = 0
while i < instructions.size
  if instructions[i][0] == 'inp'
    @batches << tmp unless tmp.empty?
    tmp = []
  end
  tmp << instructions[i]
  i += 1
end
@batches << tmp

def process(instructions, variables, input)
  instructions.each do |instruction|
    # p instruction
    operation, a, b = instruction[0], instruction[1], instruction[2]
    case operation
    when 'inp'
      variables[a] = input
    when 'add'
      b = variables.keys.include?(b) ? variables[b] : b.to_i
      variables[a] += b
    when 'mul'
      b = variables.keys.include?(b) ? variables[b] : b.to_i
      variables[a] *= b
    when 'div'
      b = variables.keys.include?(b) ? variables[b] : b.to_i
      raise 'div by 0' if b == 0
      variables[a] /= b.to_i
    when 'mod'
      b = variables.keys.include?(b) ? variables[b] : b.to_i
      raise "invalid mod: #{variables[a]} % #{b}" if variables[a] < 0 || b <= 0
      variables[a] %= b
    when 'eql'
      b = variables.keys.include?(b) ? variables[b] : b.to_i
      variables[a] = variables[a] == b ? 1 : 0
    end
    # p variables
  end
  variables
end

def batch(k, variables, input)
  variables = variables.clone
  process @batches[k], variables, input
  variables
end

def check_model_number(input)
  variables = {
    'x' => 0,
    'y' => 0,
    'z' => 0,
    'w' => 0,
  }
  14.times do |k|
    process @batches[k], variables, input[k]
    p "#{k+1}: #{variables}"
  end
  variables
end

def process_model_number(i, variables, input)
  k = input.last
  variables = batch i, variables, k
  if i == 13
    # p input
    if variables['z'] == 0
      raise "#{input.join} - bingo!"
    else
      return false
    end
  end
  na = case i
  when 1
    (1..4).to_a
  when 2
    [9]
  when 3
    [1]
  when 5
    return false if k<5
    [k-4]
  when 6
    [input[2] + 5]
  when 8
    [k]
  when 9
    (1..7).to_a
  when 10
    [k+2]
  else
    (1..9).to_a
  end
  na.reverse.each do |n|
    process_model_number i+1, variables, input + [n]
  end
  false
end

t1 = Time.new
p t1

begin
  (1..9).to_a.reverse.each do |i|
    variables = {
      'x' => 0,
      'y' => 0,
      'z' => 0,
      'w' => 0,
    }

    process_model_number(0, variables, [i])
  end
rescue => e
  p e.message
  #  validate
  # p check_model_number('98491959997994'.split('').map(&:to_i))
end

t2 = Time.now
p t2
p (t2-t1)
