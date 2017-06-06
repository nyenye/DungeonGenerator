# Dungeon Generator

This is a basic dungeon generator, inspired by Zelda NES, where every door leads to a room of equal size. There are no pathways. A Dungeon instance, is aware of the 'start_room', and the 'end_room', and have each room on a matrix of customizable size.

It's been made thought so every room will own it's entities (be it enemies, items, or furniture), so you can have many entities, but only update the ones, on the 'active_room'. Still need to be implemented though.

![dungeon generation preview](https://user-images.githubusercontent.com/11387253/26847197-73ecd9fe-4afc-11e7-96f3-ba52433f2366.gif)
