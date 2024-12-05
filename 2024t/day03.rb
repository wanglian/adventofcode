require './utils.rb'

data = get_input("03")

def p1(data)
  data.each.inject(0) do |sum, row|
    sum + row.scan(/mul\(\d{1,3},\d{1,3}\)/).each.inject(0) do |sum_row, item|
      sum_row + calc(item)
    end
  end
end

def calc(item)
  item.scan(/\d+/).map(&:to_i).inject(:*)
end

def p2(data)
  dooo = true
  data.each.inject(0) do |sum, row|
    # binding.break
    sum + row.scan(/mul\(\d{1,3},\d{1,3}\)|do\(\)|don\'t\(\)/).each.inject(0) do |sum_row, item|
      sum_row +
        case item
        when "do()"
          dooo = true
          0
        when "don't()"
          dooo = false
          0
        else
          dooo ? calc(item) : 0
        end
    end
  end
end

p p1(data)
p p2(data)
