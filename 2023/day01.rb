require './utils.rb'

data = get_input("01")

def p1(data)
  data.inject(0) do |sum, row|
    first_digit, last_digit = nil, nil
    size = row.length
    0.upto(size-1) do |i|
      break if first_digit && last_digit
      first_digit ||= match_digit_p1(row[i])
      last_digit ||= match_digit_p1(row[size-i-1])
    end
    sum + "#{first_digit}#{last_digit}".to_i
  end
end

def match_digit_p1(char)
  char.to_i.to_s == char ? char : nil
end

def p2(data)
  data.inject(0) do |sum, row|
    first_digit, last_digit = nil, nil
    size = row.length
    0.upto(size-1) do |i|
      break if first_digit && last_digit
      first_digit ||= match_digit(row[i, size-i])
      last_digit ||= reverse_match_digit(row[0, size-i])
    end
    sum + "#{first_digit}#{last_digit}".to_i
  end
end

DIGITS = %w(one two three four five six seven eight nine)
def match_digit(string)
  return string[0] if string[0].to_i.to_s == string[0]
  DIGITS.each_with_index do |d, i|
    return i+1 if string.size >= d.size && string[0, d.size] == d
  end
  nil
end

def reverse_match_digit(string)
  return string[-1] if string[-1].to_i.to_s == string[-1]
  DIGITS.each_with_index do |d, i|
    return i+1 if string.size >= d.size && string[-d.size, d.size] == d
  end
  nil
end

p p1(data)
p p2(data)
