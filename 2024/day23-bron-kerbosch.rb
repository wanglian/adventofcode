require './utils.rb'

data = get_input("23").map { |row| row.split('-')}

def parse_connections(data)
  connections = {}
  data.each do |group|
    c1, c2 = group
    connections[c1] ||= []
    connections[c1] << c2
    connections[c2] ||= []
    connections[c2] << c1
  end
  connections
end

def p1(data)
  groups = {}
  connections = parse_connections(data)
  connections.filter { |k, v| k[0] == 't' }.each do |c1, cs|
    cs.each do |c2|
      connections[c2].each do |c3|
        next if c1 == c3
        if connections[c3].include?(c1)
          groups[[c1, c2, c3].sort] = true
        end
      end
    end
  end
  groups.size
end

@max_clique = nil
def bk(clique, candidates, excluded)
  if candidates.empty? && excluded.empty?
    # p "R: #{clique}"
    # p "P: #{candidates}"
    # p "X: #{excluded}"
    # p clique
    @max_clique = clique if @max_clique.nil? || @max_clique.size < clique.size
    return
  end

  candidates.each do |candidate|
    bk(clique + [candidate], candidates & @connections[candidate], excluded & @connections[candidate])
    candidates.delete candidate
    excluded << candidate
  end
end

def p2(data)
  @connections = parse_connections(data)
  # @connections.each { |k,v| p "#{k}: #{v}" }

  bk([], @connections.keys, [])
  @max_clique.sort.join(',')
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
