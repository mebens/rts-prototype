This is a real-time strategy prototype that I'm developing with the [LÖVE](http://love2d.org) engine and my library, [Ammo](https://github.com/BlackBulletIV/ammo).

## Installation

``` bash
git clone git://github.com/BlackBulletIV/rts-prototype.git
cd rts-prototype
git submodule update --init --recursive
```

To run it, make sure you have LÖVE 0.8 installed. Then run the game using LÖVE's application or via the terminal:

``` bash
cd rts-prototype
love .
```
 
## Controls

* Left to select a group. Multiple selection isn't supported at this time.
* Right click to move a group. Drag to explicitly specify the formation the group should take.
* WASD/Arrows to move the camera.
* Q and E to rotate the camera.
* Scroll to zoom the camera.
