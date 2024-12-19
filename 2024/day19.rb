require './utils.rb'

data = get_input("19")

def p1(data)
  # binding.break
  patterns = data[0].split(', ')
  designs = data[2, data.size-2]

  count = 0
  designs.each do |design|
    count += 1 if match?(design, patterns)
  end
  count
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
  patterns = data[0].split(', ')
  designs = data[2, data.size-2]

  count = 0
  designs.each do |design|
    p "===== #{design}"
    count += matches(design, patterns)
  end
  count
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
  p "#{design}: #{result}"
  @cache[design] = result
  result
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
