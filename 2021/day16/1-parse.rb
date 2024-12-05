file = File.open 'input.txt'
data = file.readline.chomp

# data = 'D2FE28'
# data = '8A004A801A8002F478'
# data = '620080001611562C8802118E34'
# data = 'C0015000016115A2E0802F182340'
# data = 'A0016C880162017C3686B18A3D4780'

M = {
  '0' => '0000',
  '1' => '0001',
  '2' => '0010',
  '3' => '0011',
  '4' => '0100',
  '5' => '0101',
  '6' => '0110',
  '7' => '0111',
  '8' => '1000',
  '9' => '1001',
  'A' => '1010',
  'B' => '1011',
  'C' => '1100',
  'D' => '1101',
  'E' => '1110',
  'F' => '1111',
}

data = data.chars.map{|c| M[c]}.join

def parse(data, i)
  start = i
  version = data[i, 3].to_i 2
  i += 3
  type_id = data[i, 3].to_i 2
  i += 3
  # p "#{start}: #{version} - #{type_id}"

  case type_id
  when 4 # literal
    while true
      d = data[i, 5]
      i += 5
      if d[0] == '0'
        break
      end
    end
  else # operator
    length_type_id = data[i, 1]
    i += 1
    if length_type_id == '0'
      total_length = data[i, 15].to_i 2
      i += 15
      k = 0
      while k < total_length
        v, l = parse(data, i)
        version += v
        i += l
        k += l
      end
    else # '1'
      number_sub_packets = data[i, 11].to_i 2
      i += 11
      k = 0
      while k < number_sub_packets
        v, l = parse(data, i)
        version += v
        i += l
        k += 1
      end
    end
  end
  [version, i-start]
end

result = parse data, 0
p result[0]