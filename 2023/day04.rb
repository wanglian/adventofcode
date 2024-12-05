require './utils.rb'

data = get_input("04")

def p1(data)
  data.inject(0) do |sum, row|
    tmp = row.split(":")[1].strip.split("|")
    winning_numbers = tmp[0].strip.split(" ").map(&:to_i)
    having_numbers = tmp[1].strip.split(" ").map(&:to_i)
    count = 0
    having_numbers.each do |n|
      count += 1 if winning_numbers.include?(n)
    end
    points = count > 0 ? 2 ** (count - 1) : 0
    sum + points
  end
end

def p2(data)
  copies = []
  data.each_with_index.inject(0) do |sum, (row, i)|
    tmp = row.split(":")[1].strip.split("|")
    winning_numbers = tmp[0].strip.split(" ").map(&:to_i)
    having_numbers = tmp[1].strip.split(" ").map(&:to_i)
    count = 0
    having_numbers.each do |n|
      count += 1 if winning_numbers.include?(n)
    end
    current_copy = copies[i] || 0
    current_copy += 1
    1.upto(count) do |c|
      copies[i+c] ||= 0
      copies[i+c] += current_copy
    end
    sum + current_copy
  end
end

p p1(data)
p p2(data)
