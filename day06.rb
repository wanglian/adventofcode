data = File.open('input/day06.txt').readlines.map(&:chomp)[0]

def detect(data, n)
  arr = []
  data.each_char.with_index do |c, index|
    arr.push(c)
    arr.shift if arr.length > n
    if arr.uniq.length == n
      return index + 1
    end
  end
  raise "not found"
end

p detect(data, 4)
p detect(data, 14)
