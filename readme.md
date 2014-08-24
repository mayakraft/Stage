# OpenGL + UIKit interface

dramatic control over lighting, scripting, camera

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

SceneController handles transitions between scenes using Obj-C NSTimer loops and delegates, and provides tween progress between 0.0 and 1.0 to encourage elaborating upon the transition animation

curtains are see-through, they exist floating above everything else and accept touches and properly pass them to buttons and other UI elements

# examples

__2D OpenGL game:__

* 0 rooms
* curtains for menu screens
* 1 curtain for gameplay with:
* * (void)setup to allocate graphics and memory
* * (void)customDraw for frame-animations
* * touch handling with (moving) hotspots (@class Hotspot)

__3D modeling:__

* 1 room, with camera locked on origin
* 1 curtain filled with standard Apple UIKit objects

![image](https://raw.github.com/robbykraft/StagingArea/master/globe-theatre.jpg)