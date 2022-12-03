file = File.open 'input.txt'
data = file.readlines.map(&:chomp)


letters = "abcdefghijklmnopqrstuvwxyz"
letters += letters.upcase
mapping = {}
letters.split('').each_with_index do |l, i|
  mapping[l] = i+1
end

sum = 0
data.each do |row|
  c1 = row[0, row.size/2].split('').map { |l| mapping[l] }.sort
  c2 = row[row.size/2, row.size/2].split('').map { |l| mapping[l] }.sort
  i, j = 0, 0
  while i < c1.length && j < c2.length
    if c1[i] < c2[j]
      i += 1
    elsif c1[i] > c2[j]
      j += 1
    else
      sum += c1[i]
      break
    end
  end
end

p sum
