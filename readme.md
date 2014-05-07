# OpenGL Stage

lights, camera, scripts, object loader

``` objective-c
@class Stage  // parent
|
|--@class Screen  // orthographic layer sits on top of everything
|
|--@class Room  // stage decorations
```

# methods

``` objective-c
 // lights
-(void) lightsSilhouette;
-(void) lightsRainbow;
-(void) lightsSpotlightNoir;

 // camera
void setFieldOfView(fov);
void setFrame(x, y, width, height);
void setPosition(x, y, z);
void setFocus(x, y, z);

 // object file loader
-(id)initWithOBJ:(NSString*)file Path:(NSString*)path;
```

* animationDollyZoom;  // Hitchcock zoom / Vertigo zoom
* animationPerlinNoiseRotateAround;
* animationUpAndDownAndAround;

![image](https://raw.github.com/robbykraft/StagingArea/master/globe-theatre.jpg)