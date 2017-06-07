local DungeonPopulator = {
}

function DungeonPopulator.populate( dungeon, options )

   for x = 1, #dungeon.map do
     for y = 1, #dungeon.map[x] do
       if dungeon.map[x][y] ~= 0 then
       end
     end
   end

end

return DungeonPopulator
