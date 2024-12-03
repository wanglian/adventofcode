data = File.open('input/day06.txt').readlines.map(&:chomp)[0]
# binding.irb ## debug for ruby > 3

def detect(data, n)
  arr = []
  data.each_char.with_index do |c, index|
    arr.push(c)
    arr.shift if arr.length > n
    return index + 1 if arr.uniq.length == n
  end
  raise "not found"
end

p detect(data, 4)
p detect(data, 14)
