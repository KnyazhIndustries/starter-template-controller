# First person controller

The repo for "How a first person controller works in Godot 4" on Knyazh Industries (youtube.com/@KnyazhIndustries). Built on the Knyazh Industries Godot 3D project template, so the folders, settings, input map, sound buses and add-ons are the template's. Made in Godot 4.7.

## What's added to the template

- `common/player/player.tscn` and `player.gd`: the controller. A CharacterBody3D with a capsule (radius 0.4 m, height 1.8 m) and a camera at 1.6 m. Speeds are in m/s, acceleration and friction in m/s per second, the jump in metres. The player is on the Player layer (2) and collides with World (1).
- `levels/main/main.tscn`: the template's main scene, now with a floor, a light, the player and the course. Press F5.
- `levels/course/course.tscn`: a ledge, stairs with and without a ramp collider, and ramps at 30 and 50 degrees.
- The left stick on the four move actions, so a gamepad walks at partial speed.

## Using the controller in another project

Copy `common/player/` into your project.

MIT licence. The template's Kenney Prototype Kit is CC0.
