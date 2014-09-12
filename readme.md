# OpenGL + UIKit

iOS app building for getting underneath UIKit view-controllers and transitions, and customizing OpenGL, includes the Facebook-style slide menu [SWReveal menu](https://github.com/John-Lluch/SWRevealViewController).


![image](https://raw.github.com/robbykraft/StagingArea/master/globe-theatre.jpg)

``` objective-c
@class Stage  (GLKViewController)
|
|---@class Curtain    // 2D layers (touch interaction enabled)
|   |
|   |--(UIView*)view  //   UIKit attach point
|
|---@class Room       // 3D layers
∙
∙
@class SceneController
|
@protocol SceneTransitionDelegate  // animate transitions inside Stage
|
|---@property scene  // increment or goto # to call delegate animations
```

Everything is contained inside Stage. SceneController handles transitions between scenes using Obj-C NSTimer loops and delegates, and provides start to finish tween progress (0.0 to 1.0) for animation hooks.

Curtains are see-through, they exist floating above everything else and accept touches and properly pass them to buttons and other UI elements

# example use

__2D OpenGL game:__

* curtains for menu screens and 1 curtain for gameplay with:
* * (void)setup to allocate graphics and memory
* * (void)customDraw for frame-animations
* * touch handling with (moving) hotspots (@class Hotspot)

__3D modeling:__

* 1 room, with camera locked on origin
* 1 curtain filled with standard Apple UIKit objects