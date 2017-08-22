local Room = {
  dungeon = nil,
  x = 0, y = 0,
  doors = nil,
  free_walls = { 'n', 's', 'e', 'w' }
}
local room_mt = { __index = Room }

-- Constants
Constants.RoomConditions = {}
Constants.RoomConditions.KILL_ENEMIES = 1
Constants.RoomConditions.SOLVE_PUZZLE = 2

-- Methods
--[[
  Creates a new Room instance setting it's parent dungeon, and it's position on the map.
  @params dungeon [Dungeon] Dungeon instance
  @params x [int] Position X on the dungeon's map.
  @params y [int] Position Y on the dungeon's map.
  @return - Room
--]]
function Room.new( dungeon, x, y )
  local instance = {
    dungeon = dungeon,
    x = x, y = y,
    doors = {},
    free_walls = { 'n', 's', 'e', 'w' }
  }
  return setmetatable( instance, room_mt )
end

--[[
  Method called when player enters the room.
  @return void
--]]
function Room:onEnter()
  self:setDoorsLockState( self.lock_doors )
end

--[[
  Method called every update. Must update entities inside room.
  @params deltaTime [float] Time since last frame
  @return void
--]]
function Room:update( deltaTime )
  if self.lock_doors then
    local unlock = self:checkUnlockCondition()
    if unlock then
      self:setDoorsLockState( false )
      self.lock_doors = false
    end
  end
end

function Room:onExit()
end

function Room:draw()
end

function Room:checkUnlockCondition()
  if self.unlock_condition == Constants.RoomConditions.KILL_ENEMIES then
    if #self.enemies == 0 then
      return true
    end
  elseif self.unlock_condition == Constants.RoomConditions.SOLVE_PUZZLE then
    if self.puzzle.is_solved then
      return true
    end
  end
  return false
end

function Room:setDoorsLockState( state )
  for _, door in pairs(self.doors) do
    door.setIsLocked( state )
  end
end

-- Getters & Setters
function Room:setLockDoors( lockDoors )
  self.lock_doors = lockDoors
end

function Room:setUnlockCondition( condition )
  self.unlock_condition = condition
end

-- Room generation methods
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

-- Debug methods
function Room:drawDebug()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle( 'line', self.x * 50, self.y * 50, 50, 50 )
  for _, door in pairs(self.doors) do
    door:drawDebug()
  end
end

return Room
