local Room = {
  dungeon = nil,
  x = 0, y = 0,
  doors = nil,
  free_walls = { 'n', 's', 'e', 'w' }
}
local room_mt = { __index = Room }

function Room.new( dungeon, mapX, mapY )
  local instance = {
    dungeon = dungeon,
    x = mapX, y = mapY,
    doors = {},
    free_walls = { 'n', 's', 'e', 'w' }
  }
  return setmetatable( instance, room_mt )
end

function Room:addDoor( door, wall )
  self.doors[wall] = door
end

function Room:updateFreeWalls()
  local freeWalls = {}
  if self.x > 1 and self.dungeon:isRoomFree( self.x - 1, self.y) then table.insert(freeWalls, 'w') end
  if self.x < MAP_WIDTH and self.dungeon:isRoomFree( self.x + 1, self.y) then table.insert(freeWalls, 'e') end
  if self.y > 1 and self.dungeon:isRoomFree( self.x, self.y - 1) then table.insert(freeWalls, 'n') end
  if self.y < MAP_HEIGHT and self.dungeon:isRoomFree( self.x, self.y + 1) then table.insert(freeWalls, 's') end
  self.free_walls = freeWalls
end

function Room:getRandomFreeWall()
  local index = math.random(1, #self.free_walls)
  return table.remove(self.free_walls, index)
end

function Room:drawDebug()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle( 'line', self.x * 50, self.y * 50, 50, 50 )
  for _, door in pairs(self.doors) do
    door:drawDebug()
  end
end

return Room
