# OpenGL Staging Area, iOS

load OpenGL mesh / obj on stage

customize lights, camera, animation

# methods

``` objective-c
 // lights
-(void) lightsFlatBlackOnWhite;
-(void) lightsRainbow;
-(void) lightsSpotlightNoir;

 // camera
camera.setPosition(0.0f, 0.0f, 2.0f);
camera.setFocus(0.0f, 0.0f, 0.0f);

 // animation function pointer
camera.animation = &Camera::animationPerlinNoiseRotateAround;
// ::animationUpAndDownAndAround;
// ::animationDollyZoom;  // Hitchcock zoom / Vertigo zoom

```

![image](https://raw.github.com/robbykraft/StagingArea/master/globe-theatre.jpg)