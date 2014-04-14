# OpenGL Stage

simple way to layout OpenGL

lights, camera, action (scripts), and actors (objects)

# classes

``` objective-c
@class Stage // HQ

@class OBJ   // objects can be loaded from an OBJ file, and can be animated
class Camera // gluLookAt-style with CENTER, LOOK, UP vectors
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

 // action
void setAnimation(__)

 // objects
-(id)initWithOBJ:(NSString*)file Path:(NSString*)path;

```

* animationDollyZoom;  // Hitchcock zoom / Vertigo zoom
* animationPerlinNoiseRotateAround;
* animationUpAndDownAndAround;

![image](https://raw.github.com/robbykraft/StagingArea/master/globe-theatre.jpg)