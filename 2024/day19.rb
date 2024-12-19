require './utils.rb'

data = get_input("19")

def parse(data)
  patterns = data[0].split(', ')
  designs = data[2, data.size-2]
  [patterns, designs]
end

def p1(data)
  # binding.break
  patterns, designs = parse(data)

  designs.inject(0) do |sum, design|
    sum + (match?(design, patterns) ? 1 : 0)
  end
end

def match?(design, patterns)
  k = 1
  while k <= design.size
    if patterns.include?(design[0, k])
      if k == design.size
        return true
      else
        re = match?(design[k, design.size-k], patterns)
        if re
          return re
        else
          k += 1
        end
      end
    else
      k += 1
    end
  end
  false
end

def p2(data)
  patterns, designs = parse(data)

  designs.inject(0) do |sum, design|
    sum + matches(design, patterns)
  end
end

@cache = {}
def matches(design, patterns)
  return @cache[design] if @cache[design]
  k = 1
  result = 0
  while k <= design.size
    if patterns.include?(design[0, k])
      if k == design.size
        result += 1
      else
        result += matches(design[k, design.size-k], patterns)
      end
    end
    k += 1
  end
  @cache[design] = result
  result
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
