require './utils.rb'

data = {}
get_input("11").each do |row|
  device, outputs = row.split(': ')
  outputs = outputs.split(' ')
  data[device] = outputs
end

def p1(data)
  # binding.break
  # dfs(data, [], 'you')
end

@cache = {}
def dfs(data, path, current, &block)
  key = "#{path.join('-')}:#{current}".hash
  if @cache[key]
    return @cache[key]
  end

  if current == 'out'
    return block_given? ? yield(path) : 1
  end

  outputs = data[current]
  result = outputs.map do |output|
    if path.include?(output)
      0
    else
      next_path = path.dup
      next_path << current
      dfs(data, next_path, output, &block)
    end
  end.sum
  @cache[key] = result
  result
end

def p2(data)
  # TODO: improve performance
  dfs(data, [], 'svr') do |path|
    path.include?('fft') && path.include?('dac') ? 1 : 0
  end
end

def dfs2(data, path, current, out, pass)
  if current == out
    return path.include?(pass) ? 1 : 0
  end
  if current == 'out'
    return 0
  end

  outputs = data[current]
  if outputs.nil?
    p current, path
  end
  outputs.map do |output|
    if path.include?(output)
      0
    else
      next_path = path.dup
      next_path << current
      dfs2(data, next_path, output, out, pass)
    end
  end.sum
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
