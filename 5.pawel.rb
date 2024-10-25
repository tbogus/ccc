require 'scanf'
require 'awesome_print'
require 'byebug'

$debug = false

W = 3
H = 2
n, = scanf("%d")
def print_mapa(debug = $debug, out = debug ? STDERR : STDOUT)
    out.puts "-"*($mapa[0].size) if debug
    out.puts ","*($mapa[0].size) if debug
    $mapa[1..].each do |m|
        if debug
            out.puts "," + m[1..].gsub(/ /, "'")
        else
            out.puts m[1..].gsub(/ /, ".")
        end
    end
end
n.times do
  STDERR.puts ("="*80) if $debug
  x,y,c = scanf("%d%d%d")
  ap({x: x, y: y, c: c}) if $debug
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


  def ile(x, y, w = nil, h = nil)
    if w == nil && h == nil
        return [ile(x, y, W, H), ile(x, y, H, W)].max
    end
    (x/w) * (y/h)
  end

  def wypelnij(x, y, xx, yy)
    pionowo = ile(xx-x, yy-y, W, H) <= ile(xx-x, yy-y, H, W)

    w = pionowo ? H : W
    h = pionowo ? W : H
    x.step(xx-w, w) do |cx|
        y.step(yy-h, h) do |cy|
            wstaw_biurko(cx, cy, pionowo: pionowo)
        end
    end
  end

  wyniki = {}

  (0..W*H+1).each do |cx|
    next if cx >= x
    (0..W*H+1).each do |cy|
        next if cy >= y
        pola = [
            [0, cx, 0, cy],
            [cx, x, 0, cy],
            [0, cx, cy, y],
            [cx, x, cy, y]
        ].select{|x, xx, y, yy| xx >= x && yy >= y}
        wynik = pola.map{|x, xx, y, yy| ile(xx-x, yy-y) }.sum
        wyniki[wynik] = pola

        pola = [
            [0, cx+1, 0, cy],
            [cx+1, x, 0, cy+1],
            [0, cx, cy, y],
            [cx, x, cy+1, y]
        ].select{|x, xx, y, yy| xx >= x && yy >= y}
        wynik = pola.map{|x, xx, y, yy| ile(xx-x, yy-y) }.sum
        wyniki[wynik] = pola
    end
  end

  best_wynik = wyniki.keys.max
  pola = wyniki[best_wynik]
  ap(best_wynik: best_wynik, pola: pola ) if $debug

  pola.each do |x, xx, y, yy|
    wypelnij(x, y, xx, yy)
  end

  print_mapa

  raise "powinno byc #{c} a jest #{best_wynik}" if best_wynik != c
end
