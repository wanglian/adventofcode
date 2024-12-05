file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

# data = [
#   '[({(<(())[]>[[{[]{<()<>>',
#   '[(()[<>])]({[<{<<[]>>(',
#   '{([(<{}[<>[]}>{[]{[(<()>',
#   '(((({<>}<{<{<>}{[]{[]{}',
#   '[[<[([]))<([[{}[[()]]]',
#   '[{[{({}]{}}([{[{{{}}([]',
#   '{<[[]]>}<{[{[{[]{()[[[]',
#   '[<(<(<(<{}))><([]([]()',
#   '<{([([[(<>()){}]>(<<{{',
#   '<{([{{}}[<[[[<>{}]]]>[]]',
# ]

PAIRS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}
POINTS = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

errors = []
data.each do |row|
  stack = []
  row.each_char do |c|
    if PAIRS.keys.include?(c)
      stack.push(c)
    end
    if PAIRS.values.include?(c)
      expected = PAIRS[stack.pop]
      unless expected == c
        errors << c
        break
      end
    end
  end
end

p errors.inject(0) {|sum, e| sum + POINTS[e]}
