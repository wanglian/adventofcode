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
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}

errors = []
data.each do |row|
  stack = []
  corrupted = false
  row.each_char do |c|
    if PAIRS.keys.include?(c)
      stack.push(c)
    end
    if PAIRS.values.include?(c) && PAIRS[stack.pop] != c
      corrupted = true
      break
    end
  end
  unless corrupted
    errors << stack
  end
end

scores = errors.map do |error|
  error.map do |e|
    PAIRS[e]
  end.reverse.inject(0) {|sum, e| sum * 5 + POINTS[e]}
end

p scores.sort[scores.size/2]
