require './utils.rb'

data = get_input("07").map do |row|
  re = row.split(':')
  [re[0].to_i, re[1].strip.split(' ').map(&:to_i)]
end

def p1(data)
  calc(data) do |tmp, r, n|
    tmp << (r + n)
    tmp << (r * n)
  end
end

def calc(data, &block)
  result = 0
  data.each do |row|
    value, numbers = row
    answers = [numbers[0]]
    i = 1
    while i < numbers.size
      tmp = []
      n = numbers[i]
      answers.each do |r|
        yield tmp, r, n
      end
      answers = tmp
      i += 1
    end
    result += value if answers.include?(value)
  end
  result
end

def p2(data)
  calc(data) do |tmp, r, n|
    tmp << (r + n)
    tmp << (r * n)
    tmp << "#{r}#{n}".to_i
  end
end

p p1(data)
p p2(data)
