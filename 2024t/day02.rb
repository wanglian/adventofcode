require './utils.rb'

data = get_input("02")
data = data.map { |row| row.split(' ').map(&:to_i)}

def p1(data)
  # binding.break
  data.each.inject(0) do |sum, row|
    safe?(row) ? sum + 1 : sum
  end
end

def safe?(list)
  order = 0
  list.each_with_index do |v, i|
    next if i == 0
    diff = v - list[i-1]
    return false if diff.abs > 3 || diff.abs < 1
    new_order = diff > 0 ? 1 : -1
    if order == 0
      order = new_order
    else
      return false unless order == new_order
    end
  end
  true
end

def p2(data)
  data.each.inject(0) do |sum, row|
    safe2?(row) ? sum + 1 : sum
  end
end

def safe2?(list)
  return true if safe?(list)

  list.each_with_index do |v, i|
    new_list = list.dup
    new_list.delete_at i
    return true if safe?(new_list)
  end
  false
end

p p1(data)
p p2(data)
