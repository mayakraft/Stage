# OpenGL + UIKit interface

dramatic control over lighting, scripting, camera

``` objective-c
@class Stage  (GLKViewController)
|
|---@class Curtain    // subclass for 2D layers
|   |
|   |--(UIView*)view  //   UIKit attach point
|
|---@class Room       // subclass for 3D layers

@property int scene //   advance scenes to load new rooms
```

![image](https://raw.github.com/robbykraft/StagingArea/master/globe-theatre.jpg)