#ifndef __Stage__Camera__
#define __Stage__Camera__

#include <iostream>
#include <OpenGLES/ES1/gl.h>

class Camera{
public:
    
    Camera();

    void frameShot();  // call at beginning of every draw function
    
    void setFieldOfView(float fieldOfView);
    void setAspectRatio(float aspectRatio);
    void setFrame(int x, int y, int width, int height);
    
    void setPosition(GLfloat pX, GLfloat pY, GLfloat pZ);   // x,y,z of camera lens
    void setFocus(GLfloat fX, GLfloat fY, GLfloat fZ);      // x,y,z of point on which to focus
    void setUp(GLfloat uX, GLfloat uY, GLfloat uZ);         // tilt/roll around line of sight
    //    bool tiltLock;      // turn off up[3] (always above +y camera)
    
    // animation
    void (Camera::*animation)() = NULL;
    void setAnimation(/*function pointer*/);
    // make your own animation scripts
    void animationUpAndDownAndAround();
    void animationDollyZoom();
    void animationPerlinNoiseRotateAround();
    
    float       Z_NEAR = 0.1f;
    float       Z_FAR = 100.0f;
    
private:
    void rebuildProjectionMatrix();
    void enterOrthographic();
    void exitOrthographic();
    void logOrientation();

    GLfloat     position[3] = {0.0f, 0.0f, 0.0f};  // x,y,z of camera lens
    GLfloat     focus[3] = {0.0f, 0.0f, 1.0f};     // x,y,z of point on which to focus
    GLfloat     up[3] = {0.0f, 1.0f, 0.0f};        // tilt/roll around line of sight
    
    GLfloat     m[16];  // orientation
    float       _fieldOfView = 45.0f;
    float       _aspectRatio = 1.0f;
    float       _screenX;
    float       _screenY;
    float       _screenWidth;
    float       _screenHeight;
    
    // for calculating orientation matrix
    float forward[3], side[3], above[3];
};

#endif /* defined(__Stage__Camera__) */
