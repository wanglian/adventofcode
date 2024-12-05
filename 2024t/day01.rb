require './utils.rb'

data = get_input("01")

def p1(data)
  # binding.break
  list1, list2 = init(data)

  list1.sort!
  list2.sort!

  list1.each_with_index.inject(0) do |sum, (v, i)|
    sum + (v - list2[i]).abs
  end
end

def init(data)
  list1, list2 = [], []
  data.each do |row|
    v1, v2 = row.split('   ')
    list1 << v1.to_i
    list2 << v2.to_i
  end

  [list1, list2]
end

def p2(data)
  list1, list2 = init(data)

  list1.each.inject(0) do |sum, v|
    sum + v * list2.count(v)
  end
end

p p1(data)
p p2(data)
