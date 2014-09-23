# OpenGL + UIKit

mini iOS framework for getting underneath UIKit view-controllers and transitions, and seamlessly integrating 3D and OpenGL alongside Apple’s UIKit

# includes

* the Facebook-style slide menu [SWReveal](https://github.com/John-Lluch/SWRevealViewController)
* UIScrollView + OpenGL fix, the fix for the freezing draw loop problem (see WWDC 2012)
* 2D OpenGL primitives

![image](https://raw.github.com/robbykraft/StagingArea/master/globe-theatre.jpg)

``` objective-c
@class Stage  (GLKViewController)
|
|---@class GLView     // 2D layers (touch interaction enabled for UIKit subviews)
|
|---@class Room       // 3D layers
.
.
@class SceneController
|
@protocol SceneTransitionDelegate  // animate transitions inside Stage
|
|---@property scene  // increment or goto # to call delegate animations
```

Everything is contained inside Stage. SceneController handles transitions between scenes using Obj-C NSTimer loops and delegates, and provides start to finish tween progress (0.0 to 1.0) for animation hooks.

Curtains are see-through, they exist floating above everything else and accept touches and properly pass them to buttons and other UI elements