file = File.open 'input.txt'
data = file.readline.chomp.split(',').map(&:to_i)
## for test
# data = [3,4,3,1,2]
DAYS = 256

@cache = {}

def count(n, day)
  return 1 if day == 0
  key = "#{n}-#{day}"
  return @cache[key] if @cache[key]
  re = if n == 0
    count(6, day-1) + count(8, day-1)
  else
    count(n-1, day-1)
  end
  @cache[key] = re
  re
end

result = data.inject(0) {|sum, d| sum + count(d, DAYS)}

p result
