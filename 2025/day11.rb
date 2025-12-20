require './utils.rb'

data = {}
get_input("11").each do |row|
  device, outputs = row.split(': ')
  outputs = outputs.split(' ')
  data[device] = outputs
end

def p1(data)
  dfs(data, [], 'you')
end

def dfs(data, path, current)
  if current == 'out'
    return 1
  end

  outputs = data[current]
  outputs.map do |output|
    if path.include?(output)
      0
    else
      next_path = path.dup
      next_path << current
      dfs(data, next_path, output)
    end
  end.sum
end

def p2(data)
  dfs2(data, [], 'svr', 0)
end

@cache = {}
def dfs2(data, path, current, pass)
  key = "#{current}-#{pass}"
  if @cache[key]
    return @cache[key]
  end

  if current == 'out'
    return pass == 3 ? 1 : 0
  end

  outputs = data[current]
  result = outputs.map do |output|
    if path.include?(output)
      0
    else
      next_path = path.dup
      next_path << current
      dfs2(data, next_path, output, check_pass(pass, current))
    end
  end.sum
  @cache[key] = result
  result
end

def check_pass(pass, current)
  pass |= 1 if current == 'fft'
  pass |= 2 if current == 'dac'
  pass
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
