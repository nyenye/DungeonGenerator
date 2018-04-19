local Door = {
  room = nil,
  ox = 0, oy = 0,
  wall = nil
}
local door_mt = { __index = Door }

function Door.new( room, wall )
  local offx, offy = Door.getOffsetFromWall( wall )
  local instance = {
    room = room,
    wall = wall,
    ox = offx, oy = offy
  }
  return setmetatable( instance, door_mt )
end

function Door.getOffsetFromWall( wall )
  local ox, oy = 0, 0
  if wall == 'n' then
    oy = -1
  elseif wall == 's' then
    oy = 1
  elseif wall == 'e' then
    ox = 1
  else
    ox = -1
  end -- wall == 'w'
  return ox, oy
end

function Door.getWallFromParent( parentWall )
  if parentWall == 'n' then return 's'
  elseif parentWall == 's' then return 'n'
  elseif parentWall == 'e' then return 'w'
  else return 'e'
  end
end

function Door:drawDebug()
  local offsetX, offsetY
  if self.ox == 1 then -- 'e'
    offsetX, offsetY = 48, 25
    love.graphics.setColor(0, 255, 0, 255)
  elseif self.ox == -1 then -- 'w'
    offsetX, offsetY = 2, 25
    love.graphics.setColor(255, 255, 0, 255)
  elseif self.oy == 1 then -- 's'
    offsetX, offsetY = 25, 48
    love.graphics.setColor(255, 0, 0, 255)
  elseif self.oy == -1 then -- 'n'
    offsetX, offsetY = 25, 2
    love.graphics.setColor(0, 0, 255, 255)
  end
  love.graphics.circle('fill', self.room.x * 50 + offsetX, self.room.y * 50 + offsetY, 2)
end

return Door
