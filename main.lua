local DungeonGenerator = require 'lib/dungeon_generator'
Constants = {}

local dungeon

function love.load()
  love.window.setTitle('Dungeon Generator')
  love.window.setMode(350, 350)
  dungeon = DungeonGenerator.new( { rooms_number = 20 } )
  dungeon:printMapToFile('dungeon.txt', 'w')
end

function love.draw()
  love.graphics.print('Press \'RETURN\' to generate dungeon again.', 10, 10)
  dungeon:drawDebug()
end

function love.keyreleased(key)
  if key == 'return' then
    dungeon = DungeonGenerator.new( { rooms_number = 10 })
    dungeon:printMapToFile('dungeon.txt', 'a')
  end
end
