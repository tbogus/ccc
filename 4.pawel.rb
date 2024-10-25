require 'scanf'
require 'awesome_print'
require 'byebug'

$debug = false

W = 4
H = 2
n, = scanf("%d")
def print_mapa(debug = $debug, out = debug ? STDERR : STDOUT)
    out.puts "-"*($mapa[0].size) if debug
    out.puts ","*($mapa[0].size) if debug
    $mapa[1..].each do |m|
        if debug
            out.puts "," + m[1..]
        else
            out.puts m[1..].gsub(/ /, ".")
        end
    end
end
n.times do
  STDERR.puts ("="*80) if $debug
  x,y,c = scanf("%d%d%d")
  x += 1
  y += 1
  $mapa = (1..y).to_a.map { (" " * x) }

  def wstaw_biurko(x, y, pionowo: true)
    STDERR.puts("wstawiam biurko w #{x},#{y} #{pionowo ? "pionowo" : "poziomo"}") if $debug
    ww = pionowo ? H : W
    hh = pionowo ? W : H
    (0...ww).each { |xx| (0...hh).each { |yy| raise "cos jest na mapie w #{x+xx},#{y+yy} przy stawianiu biurka w #{x},#{y}" if $mapa[y+yy][x+xx] != " " }}
    (0...ww).each { |xx| (0...hh).each { |yy| $mapa[y+yy][x+xx] = (yy==0 || xx==0) ? '.' : 'X' }}
  rescue
    print_mapa(true)
    (0...ww).each { |xx| (0...hh).each { |yy| $mapa[y+yy][x+xx] = 'E' }}
    print_mapa(true)
    raise
  end

  (0...y/W).each do |cy|
    (0...(x/H)).each do |cx|
        wstaw_biurko(cx * H, cy * W, pionowo: true)
    end
  end

  
  (0...(y % W)/H).each do |cy|
    cy += y - (y % W) + cy * H
    (0...(x/W)).each do |cx|
        cx *= W
        wstaw_biurko(cx, cy, pionowo: false)
    end
  end

#   while (y >= 0)
#     (0...(x/W)).each do |j|
#       printf("%d %d %d ", i+j, i+j, i+j)
#     end
#     puts((["0"] * (x%W)).join(" "))
#     i += x/W
#     y -= H
#   end
  print_mapa
end
