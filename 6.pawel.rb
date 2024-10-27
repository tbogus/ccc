require 'scanf'
require 'awesome_print'
require 'byebug'

$debug = false

W = 3
H = 2
n, = scanf("%d")
def print_mapa(mapa, debug = $debug, out = debug ? STDERR : STDOUT)
    out.puts "-"*(mapa[0].size) if debug
    out.puts ","*(mapa[0].size) if debug
    mapa[1..].each do |m|
        if debug
            out.puts "," + m[1..].gsub(/ /, "'")
        else
            out.puts m[1..].gsub(/ /, ".")
        end
    end
end
n.times do
  STDERR.puts ("="*80) if $debug
  x,y,c,szerokosc = scanf("%d%d%d%d")
  szerokosc += 1
  x += 1
  y += 1
  ap({x: x, y: y, c: c, szerokosc: szerokosc}) if $debug
  X, Y, W = x, y, szerokosc

  def wstaw_biurko(mapa, x, y, pionowo: true)
    STDERR.puts("wstawiam biurko w #{x},#{y} #{pionowo ? "pionowo" : "poziomo"}") if $debug
    ww = pionowo ? H : W
    hh = pionowo ? W : H
    (0...ww).each { |xx| (0...hh).each { |yy| raise "cos jest na mapie w #{x+xx},#{y+yy} przy stawianiu biurka w #{x},#{y}" if mapa[y+yy][x+xx] != " " }} if $debug
    (0...ww).each { |xx| (0...hh).each { |yy| mapa[y+yy][x+xx] = (yy==0 || xx==0) ? '.' : 'X' }}
  rescue
    print_mapa(mapa, true)
    (0...ww).each { |xx| (0...hh).each { |yy| mapa[y+yy][x+xx] = 'E' }}
    print_mapa(mapa, true)
    raise
  end


  def ile(x, y, w = nil, h = nil)
    return 0 if x <= 0 || y <= 0
    if w == nil && h == nil
        return [ile(x, y, W, H), ile(x, y, H, W)].max
    end
    (x/w) * (y/h)
  end

  def wypelnij(mapa, x, y, xx, yy)
    pionowo = ile(xx-x, yy-y, W, H) <= ile(xx-x, yy-y, H, W)

    w = pionowo ? H : W
    h = pionowo ? W : H
    STDERR.puts "wypelniam od #{x},#{y} do #{xx},#{yy} pionowo: #{pionowo}" if $debug
    ile_powinno_byc = ile(xx-x, yy-y, w, h)
    ile_jest = 0
    x.step(xx-w, w) do |cx|
        y.step(yy-h, h) do |cy|
            STDERR.puts "stawiam #{cx},#{cy}" if $debug
            # raise "wychodze za zakres X" if cx+w > xx
            # raise "wychodze za zakres Y" if cy+h > yy
            wstaw_biurko(mapa, cx, cy, pionowo: pionowo)
            ile_jest += 1
        end
    end
    if ile_powinno_byc != ile_jest
        raise "zle liczy kwadrat #{x},#{y} #{xx},#{yy} pionowo: #{pionowo} powinno byc #{ile_powinno_byc} a jest #{ile_jest}"
    end
  end

  def iteruj(x, y)
    (0..W*H+1).each do |cx|
        next if cx > x
        (0..W*H+1).each do |cy|
            next if cy > x
            (0...W+1).each do |dx|
                (0...W+1).each do |dy|
                    pola = [
                        [0, cx+dx, 0, cy],
                        [cx+dx, x, 0, cy+dy],
                        [cx, cx+dx, cy, cy+dy], # dziura
                        [0, cx, cy, y],
                        [cx, x, cy+dy, y]
                    ]
                    yield pola
                end
            end
        end
    end

    (0..(W+1)*(H+1)).each do |cx|
        next if cx > x
        (0..(W+1)*(H+1)).each do |cy|
    #   (0..W*H+1).each do |cx|
    #     next if cx > x
    #     (0..W*H+1).each do |cy|
            next if cy > y
            (0...W+1).each do |dx|
                (0...W+1).each do |dy|
                    ((cx+dx)...x).each do |ox|
                    # (cx+dx).step(x, W) do |ox|
                        pola = [
                            [0, cx+dx, 0, cy],
                            [cx+dx, ox, 0, cy+dy],
                            [cx, cx+dx, cy, cy+dy], # dziura
                            [0, cx, cy, y],
                            [cx, ox, cy+dy, y],
                            [ox, x, 0, y],
                        ]
                        yield pola
                    end
                    # (cy+dy).step(y, W) do |oy|
                    ((cy+dy)...y).each do |oy|
                        pola = [
                            [0, cx+dx, 0, cy],
                            [cx+dx, x, 0, cy+dy],
                            [cx, cx+dx, cy, cy+dy], # dziura
                            [0, cx, cy, oy],
                            [cx, x, cy+dy, oy],
                            [0, x, oy, y]
                        ]
                        yield pola
                    end

                    ((cx+dx)...x).each do |ox|
                        ((cy+dy)...y).each do |oy|
                            pola = [
                                [0, cx+dx, 0, cy],
                                [cx+dx, ox, 0, cy+dy],
                                [cx, cx+dx, cy, cy+dy], # dziura
                                [0, cx, cy, oy],
                                [cx, ox, cy+dy, oy],
                                [ox, x, 0, oy],
                                [0, x, oy, y],
                            ]
                            yield pola
                            # pola = [
                            #     [0, cx+dx, 0, cy],
                            #     [cx+dx, ox, 0, cy+dy],
                            #     [cx, cx+dx, cy, cy+dy], # dziura
                            #     [0, cx, cy, oy],
                            #     [cx, ox, cy+dy, oy],
                            #     [0, x, 0, oy],
                            #     [ox, x, 0, y],
                            # ]
                            # yield pola
                        end
                    end
                    # (cy+dy).step(y, W) do |oy|
                    #     pola = [
                    #         [0, cx+dx, 0, cy],
                    #         [cx+dx, x, 0, cy+dy],
                    #         [cx, cx+dx, cy, cy+dy], # dziura
                    #         [0, cx, cy, oy],
                    #         [cx, x, cy+dy, oy],
                    #         [0, x, oy, y]
                    #     ]
                    #     pola.select!{|x, xx, y, yy| xx > x && yy > y && x >= 0 && y >= 0 && xx <= X && yy <= Y}
                    #     wynik = pola.map{|x, xx, y, yy| ile(xx-x, yy-y) }.sum
                    #     wyniki[wynik] = pola
                    # end
                end
            end
        end
    end
  end

  best_wynik = 0
  best_pola = []

  def assert_empty_intersection(a, b) 
    return if a[1] <= b[0] || b[1] <= a[0] || a[3] <= b[2] || b[3] <= a[2]
    raise "niepuste przeciecie #{a} i #{b}"
  end

  iteruj(x, y) do |pola| 
    pola.select!{|x, xx, y, yy| xx > x && yy > y && x >= 0 && y >= 0 && xx <= X && yy <= Y}
    pola.each_with_index { |a, i| pola[(i+1)..].each { |b| assert_empty_intersection(a, b) } } if !$debug
    wynik = pola.map{|x, xx, y, yy| ile(xx-x, yy-y) }.sum
    if wynik > best_wynik
        best_wynik = wynik
        best_pola = pola
        if wynik == c
            break 
        end
    end
  end

  ap(best_wynik: best_wynik, best_pola: best_pola ) if $debug

  mapa = (1..y).to_a.map { (" " * x) }
  best_pola.each do |x, xx, y, yy|
    wypelnij(mapa, x, y, xx, yy)
  end

  print_mapa mapa

  if best_wynik != c
    ap({x: x, y: y, c: c, szerokosc: szerokosc})
    raise "wynik powinien byc #{c} a jest #{best_wynik}" 
  end
end
