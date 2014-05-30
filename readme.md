# OpenGL Stage

3D environment for app building with dramatic control over lighting and camera

``` objective-c
@class Stage  // dispatch for user-feedback and timing animations
|
|--@class Screen  // on top: orthographic layer for all 2D user interface
|
|--@class Room    // below: the 3D world
```

![image](https://raw.github.com/robbykraft/StagingArea/master/globe-theatre.jpg)