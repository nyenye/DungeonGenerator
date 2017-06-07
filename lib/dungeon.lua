local Dungeon = {
  map = nil,
  active_room = nil,
  start_room = nil,
  mid_room = nil,
  end_room = nil,
}
local dungeon_mt = { __index = Dungeon }

function Dungeon.new( )
  local instance = {}
  return setmetatable( instance, dungeon_mt )
end

function Dungeon:setMap( map )
  self.map = map
end

function Dungeon:setActiveRoom( x, y )
  self.active_room = self.map[x][y]
end

function Dungeon:setStartRoom( startRoom )
  self.start_room = startRoom
end

function Dungeon:setMidRoom( midRoom )
  self.mid_room = midRoom
end

function Dungeon:setEndRoom( endRoom )
  self.end_room = endRoom
end

function Dungeon:isRoomFree( x, y )
  if self.map[x][y] == 0 then
    return true
  end
  return false
end

function Dungeon:drawDebug()
  for x=1,#self.map do
    for y=1,#self.map[x] do
      if self.map[x][y] then
        self.map[x][y]:drawDebug()
      end
    end
  end
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.print('S', self.start_room.x * 50 + 20, self.start_room.y * 50 + 18)
  love.graphics.setColor(0, 0, 255, 255)
  love.graphics.print('M', self.mid_room.x * 50 + 20, self.mid_room.y * 50 + 18)
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.print('E', self.end_room.x * 50 + 20, self.end_room.y * 50 + 18)
end

function Dungeon:printMapToFile( fileName, mode )
  local file = io.open(fileName, mode)
  file:write('-----DUNGEON------', '\n')
  file:write('active_room - x: ', self.active_room.x, ', y: ', self.active_room.y, '\n')
  file:write('   ')
  for x=1,#self.map[1] do
    file:write('[', x, ']')
  end
  file:write('\n')
  for y=1,#self.map do
    file:write('[', y, ']')
    for x=1,#self.map[y] do
      if not self.map[x][y] then
        file:write('[ ]')
      elseif self.map[x][y] == self.start_room then
        file:write('[s]')
      elseif self.map[x][y] == self.active_room then
        file:write('[a]')
      elseif self.map[x][y] == self.end_room then
        file:write('[e]')
      else
        file:write('[r]')
      end
    end
    file:write('\n')
  end
  file:write()
  file:close()
end

return Dungeon
