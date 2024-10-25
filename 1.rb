i = gets.chomp.to_i
res = []
i.times do
  word = gets.chomp
  word = word.split(" ")
  word = word.map(&:to_i).reduce(1, :*)

  res << word / 3
end

File.open("output1.txt", "w") do |file|
  res.each do |r|
    file.puts r
  end
end
