file = File.open 'input.txt'
data = file.readlines.map(&:chomp)


letters = "abcdefghijklmnopqrstuvwxyz"
letters += letters.upcase
mapping = {}
letters.split('').each_with_index do |l, i|
  mapping[l] = i+1
end

sum = 0
n = 0
while (n + 2) < data.length
  c1 = data[n].split('').map { |l| mapping[l] }.sort
  c2 = data[n+1].split('').map { |l| mapping[l] }.sort
  c3 = data[n+2].split('').map { |l| mapping[l] }.sort
  i, j, k = 0, 0, 0
  while i < c1.length && j < c2.length && k < c3.length
    if c1[i] < c2[j]
      i += 1
    elsif c2[j] < c3[k]
      j += 1
    elsif c3[k] < c1[i]
      k += 1
    else c1[i] == c2[j] && c1[i] == c3[k]
      sum += c1[i]
      break
    end
  end
  n += 3
end

p sum
