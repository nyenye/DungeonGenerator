
local Dungeon = require 'lib/dungeon'
local Room = require 'lib/room'
local Door = require 'lib/door'

--[[
  LICENSE - MIT License

  This is a basic dungeon generator, inspired by Zelda NES, where every door
  leads to a room of equal size. There are no pathways. A Dungeon instance,
  is aware of the 'start_room', and the 'end_room', and have each room on a
  matrix of customizable size.

  It's been made thought so every room will own it's entities (be it enemies,
  items, or furniture), so you can have many entities, but only update the ones,
  on the 'active_room'. Still need to be implemented though.
--]]

local DungeonGenerator = {
}

-- MAP_WIDTH and MAP_HEIGHT, could be defined on a table full of global values
MAP_WIDTH = 5
MAP_HEIGHT = 5

function DungeonGenerator.newDungeon( options )
  -- Instantiate empty dungeon.
  local dungeon = Dungeon.new( )

  -- Craete matrix for the dungeon map.
  local map = {}
  for x = 1, MAP_WIDTH do
    map[x] = {}
    for y = 1, MAP_HEIGHT do
      map[x][y] = 0
    end
  end
  dungeon:setMap( map )

  -- Pick random location to as startRoom.
  local x, y = DungeonGenerator.pickRandomStart()
  local startRoom = Room.new( dungeon, x, y )
  dungeon:setStartRoom( startRoom )

  local roomsLeft = math.min(options.rooms_number, MAP_WIDTH * MAP_HEIGHT) - 1
  -- Add startRoom to activeRooms to add doors to it.
  local activeRooms = { startRoom }
  local endRoom

  while(#activeRooms > 0) do
    -- Get first room, and remove it from the list of activeRooms
    local room = table.remove(activeRooms, 1)
    map[room.x][room.y] = room
    room:updateFreeWalls()

    -- Generate doors for the room and...
    local addedDoors = DungeonGenerator.addDoors( room, math.min(1, roomsLeft, #room.free_walls), math.min(4, roomsLeft, #room.free_walls) )
    roomsLeft = roomsLeft - #addedDoors

    -- ... create corresponding rooms, and add them to the list of activeRooms
    for i, door in ipairs(addedDoors) do
      local newRoom = DungeonGenerator.addRoom( map, dungeon, room, door )
      table.insert(activeRooms, newRoom )
      map[newRoom.x][newRoom.y] = newRoom
    end

    -- If there are no more rooms to process, set endRoom to room
    if #activeRooms == 0 then endRoom = room end
  end

  -- Set startRoom as active_room. Then set endRoom.
  dungeon:setActiveRoom( startRoom.x, startRoom.y )
  dungeon:setEndRoom( endRoom )

  -- Return filled dungeon
  return dungeon
end

function DungeonGenerator.pickRandomStart()
  math.randomseed( os.time() )
  return math.random( 1, MAP_WIDTH ), math.random( 1, MAP_HEIGHT )
end

function DungeonGenerator.addRoom( map, dungeon, parentRoom, parentDoor )
  local mapX = parentRoom.x + ( parentDoor.ox )
  local mapY = parentRoom.y + ( parentDoor.oy )

  local roomToAdd = Room.new( dungeon, mapX, mapY)

  local wallToParent = Door.getWallFromParent(parentDoor.wall)
  local doorToParent = Door.new( roomToAdd, wallToParent)
  roomToAdd:addDoor( doorToParent, wallToParent )

  return roomToAdd
end

function DungeonGenerator.addDoors( room, minDoors, maxDoors )
  local numDoors = math.random(minDoors, maxDoors)

  local doors = {}
  for d = 1, numDoors do
    local wall = room:getRandomFreeWall()
    local door = Door.new( room, wall )
    room:addDoor( door, wall )
    table.insert(doors, door)
  end

  return doors
end

return DungeonGenerator
