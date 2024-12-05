file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

bits = []
data.each do |row|
  row.each_char.with_index do |c, i|
    base = 2**(i+1) - 1
    value = row[0, i+1].to_i 2
    pos = base + value
    bits[pos] ||= 0
    bits[pos] += 1
  end
end

oxygen_rating = ""
co2_rating = ""
i = 0
length = data.first.length
while i < length
  base = 2**i - 1
  
  value = oxygen_rating.to_i 2
  pos = base + value
  lc = bits[2*pos+1] || 0
  rc = bits[2*pos+2] || 0
  p "O: #{lc} - #{rc}"
  if rc == 0
    oxygen_rating << '0'
  elsif lc == 0
    oxygen_rating << '1'
  elsif lc > rc
    oxygen_rating << '0'
  else
    oxygen_rating << '1'
  end
  p oxygen_rating

  value = co2_rating.to_i 2
  pos = base + value
  lc = bits[2*pos+1] || 0
  rc = bits[2*pos+2] || 0
  p "C: #{lc} - #{rc}"
  if lc == 0
    co2_rating << '1'
  elsif rc == 0
    co2_rating << '0'
  elsif lc > rc
    co2_rating << '1'
  else
    co2_rating << '0'
  end
  p co2_rating

  i += 1
end

p "Number of binaries: #{data.size}"
p "Oxygen rating: #{oxygen_rating}"
p "CO2 rating: #{co2_rating}"

oxygen_rating = oxygen_rating.to_i 2
co2_rating = co2_rating.to_i 2
p "Rating: #{oxygen_rating * co2_rating}"
