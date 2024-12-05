file = File.open 'input.txt'
data = file.readline.chomp

# data = 'D2FE28'
# data = 'C200B40A82' # 3
# data = '04005AC33890' # 54
# data = '880086C3E88112' # 7
# data = 'CE00C43D881120' # 9
# data = 'D8005AC2A8F0' # 1
# data = 'F600BC2D8F' # 0
# data = '9C005AC2F8F0' # 0
# data = '9C0141080250320F1802104A08' # 1

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
    vs = []
    while true
      d = data[i, 5]
      i += 5
      vs << d[1, 4] #.to_i(2)
      if d[0] == '0'
        break
      end
    end
    v = vs.join.to_i(2)
  else # operator
    length_type_id = data[i, 1]
    i += 1
    vs = []
    if length_type_id == '0'
      total_length = data[i, 15].to_i 2
      i += 15
      k = 0
      while k < total_length
        v, l = parse(data, i)
        vs << v
        i += l
        k += l
      end
    else # '1'
      number_sub_packets = data[i, 11].to_i 2
      i += 11
      k = 0
      while k < number_sub_packets
        v, l = parse(data, i)
        vs << v
        i += l
        k += 1
      end
    end
    v = case type_id
    when 0
      vs.sum
    when 1
      vs.inject(1) {|p, i| p * i}
    when 2
      vs.min
    when 3
      vs.max
    when 5
      vs[0] > vs[1] ? 1 : 0
    when 6
      vs[0] < vs[1] ? 1 : 0
    when 7
      vs[0] == vs[1] ? 1 : 0
    end
  end
  [v, i-start]
end

result = parse data, 0
p result[0]