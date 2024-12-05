file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

# data = [
#   "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe",
#   "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc",
#   "fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg",
#   "fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb",
#   "aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea",
#   "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb",
#   "dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe",
#   "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef",
#   "egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb",
#   "gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"
# ]

def parse(examples)
  codes = []
  codes[1] = examples[0]
  codes[4] = examples[2]
  codes[7] = examples[1]
  codes[8] = examples[9]
  examples[6, 3].each do |c|
    if (c.chars - codes[1].chars).size == 5
      codes[6] = c
    elsif (c.chars - codes[7].chars - codes[4].chars).size == 1
      codes[9] = c
    else
      codes[0] = c
    end
  end
  examples[3, 3].each do |c|
    if (c.chars - codes[1].chars).size == 3
      codes[3] = c
    elsif (codes[9].chars - c.chars).size == 1
      codes[5] = c
    else
      codes[2] = c
    end
  end
  codes
end

sum = data.map do |row|
  examples, digits = row.split(' | ').map {|d| d.split(' ').map(&:chars).map(&:sort).map(&:join)}
  examples = examples.sort_by {|s| s.length}
  codes = parse examples
  result = digits.map {|d| codes.index d}.join.to_i
end.sum

p sum
