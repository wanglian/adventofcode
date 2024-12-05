file = File.open 'input.txt'
data = file.readline.chomp.split(',').map(&:to_i)
# data = [16,1,2,0,4,2,7,1,2,14] # for test

# data.sort!

def count(data, n)
  sum = 0
  data.each do |d|
    diff = (d - n).abs
    sum += diff * (diff + 1)/2
  end
  sum
end

re = data.map {|d| count(data, d)}.sort.first

p re
