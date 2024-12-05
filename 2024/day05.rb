require './utils.rb'

data = get_input("05")

rules = []
pages = []

target = rules
data.each do |row|
  if row.empty?
    target = pages
  else
    target << row
  end
end

rules = rules.map { |rule| rule.split("|").map(&:to_i) }
pages = pages.map { |page| page.split(",").map(&:to_i) }

def p1(rules, pages)
  pages.each.inject(0) do |sum, numbers|
    sum + if valid_pages?(numbers, rules)
      numbers[numbers.size/2]
    else
      0
    end
  end
end

def valid_pages?(numbers, rules)
  numbers.each_with_index do |m, i|
    j = i+1
    while j < numbers.size
      return false unless valid_page?(m, numbers[j], rules)
      j += 1
    end
  end
  true
end

def valid_page?(m, n, rules)
  rules.each do |rule|
    if rule.include?(m) && rule.include?(n)
      return m == rule[0]
    end
  end
  true
end

def p2(rules, pages)
  pages.each.inject(0) do |sum, numbers|
    sum + if valid_pages?(numbers, rules)
      0
    else
      numbers = correct(numbers, rules)
      numbers[numbers.size/2]
    end
  end
end

def correct(numbers, rules)
  numbers.each_with_index do |m, i|
    j = i+1
    while j < numbers.size
      if valid_page?(m, numbers[j], rules)
        j += 1
      else
        numbers[i], numbers[j] = numbers[j], numbers[i]
        m = numbers[i]
        j = i+1
      end
    end
  end
end

p p1(rules, pages)
p p2(rules, pages)
