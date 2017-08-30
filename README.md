# Fantasy Tree

A small package of a few script and shader effects.
A script attached to the main camera will allow you to move around the demo scene when played.

![](http://i.imgur.com/svj5Pvc.gif)

## Pixel Burn Effect

I created a simple leaf model in Maya and applied the [pixel burn effect shader](https://github.com/Shealynntate/Pixel-Burn-Effect).

![](http://i.imgur.com/DmMSJFD.gif)

## Hover Orbs

I added some orbs that float out of the pond at random intervals and then disappear using the [burn reveal shader](https://github.com/Shealynntate/Pixel-Burn-Effect).
Their world positions are also passed to the water material to allow the glow spots to appear as they leave the pond.

![](http://i.imgur.com/dcsP0Rg.gif)

## Water Reflection

The ripples on the water surface were made with a shader effect.
First a reflection camera rendered the scene to a render texture. That was then passed to the pond material which applied
a sin wave based distortion on the uv coordinates over time.

## Setup

Simply [download](https://github.com/Shealynntate/Fantasy_Tree/releases) the package and import it into a Unity project.
The demo scene will run as shown above.

## License 
[MIT License]
