data = File.open('input/day13.txt').readlines.map(&:chomp)
  .map { |row| eval(row) }
  .select { |row| row }

class NewArray < Array
  attr_accessor :list

  def initialize(array)
    @list = array
  end

  def <=>(other)
    compare(self.list, other.list)
  end

  def inspect
    list.inspect
  end

  def compare(list1, list2)
    return -1 if list1.empty? && !list2.empty?
    i = 0
    while i < list1.length
      return 1 if list2.length <= i
      if list1[i].is_a?(Integer) && list2[i].is_a?(Integer)
        return -1 if list1[i] < list2[i]
        return 1 if list1[i] > list2[i]
      else
        p1 = list1[i].is_a?(Array) ? list1[i] : [list1[i]]
        p2 = list2[i].is_a?(Array) ? list2[i] : [list2[i]]
        re = compare(p1, p2)
        return re unless re == 0
      end
      i += 1
    end
    return -1 if i < list2.length
    0
  end
end

def p1(data)
  data.each_slice(2).to_a.map.with_index do |pair, i|
    p1 = NewArray.new(pair[0])
    p2 = NewArray.new(pair[1])
    re = p1 <=> p2
    re == -1 ? i + 1 : 0
  end.sum
end

def p2(data)
  data << [[2]]
  data << [[6]]
  data = data.map { |row| NewArray.new(row)}.sort { |p1, p2| p1 <=> p2 }.map(&:list)

  i1 = data.index([[2]]) + 1
  i2 = data.index([[6]]) + 1
  i1 * i2
end

p p1(data)
p p2(data)
