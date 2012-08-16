task :default do
  puts `/Applications/love.app/Contents/MacOS/love .`
end

task :lines do
  puts `wc -l *.lua entities/*.lua worlds/*.lua`
end

task :package do
  puts `zip -r rts-prototype.love ammo assets entities lib worlds *.lua`
end
