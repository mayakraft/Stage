@interface Camera : NSObject

@property CGRect frame;

-(void) frameShot;  // call at beginning of every draw function

-(void) enterOrthographic;
-(void) exitOrthographic;
-(void) logOrientation;

-(void) setFieldOfView:(float) fieldOfView;
-(void) setAspectRatio:(float) aspectRatio;
-(void) setFrame:(CGRect)frame;

void setPosition(GLfloat pX, GLfloat pY, GLfloat pZ);   // x,y,z of camera lens
void setFocus(GLfloat fX, GLfloat fY, GLfloat fZ);      // x,y,z of point on which to focus
void setUp(GLfloat uX, GLfloat uY, GLfloat uZ);         // tilt/roll around line of sight
//    bool tiltLock;      // turn off up[3] (always above +y camera)

// animation
//void (Camera::*animation)() = NULL;
//void setAnimation();
// make your own animation scripts
void animationUpAndDownAndAround();
void animationDollyZoom();
void animationPerlinNoiseRotateAround();

void rebuildProjectionMatrix();
void normalize(float v[3]);
void cross(float v1[3], float v2[3], float result[3]);

@end



//
// ORIGINAL C IMPLEMENTATION
//
/*
#ifndef __Camera__
#define __Camera__

#include <OpenGLES/ES1/gl.h>

typedef struct Camera Camera;

struct Camera{
    GLfloat     position[3];  // x,y,z of camera lens
    GLfloat     focus[3];     // x,y,z of point on which to focus
    GLfloat     up[3];        // tilt/roll around line of sight
    
    GLfloat     m[16];  // orientation
    
    // for calculating orientation matrix
    float forward[3], side[3], above[3];
};

void frame_shot(Camera *cam);
void build_projection_matrix(float x, float y, float w, float h, float FOV);

void set_position(Camera *cam, GLfloat pX, GLfloat pY, GLfloat pZ);
void set_focus(Camera *cam, GLfloat fX, GLfloat fY, GLfloat fZ);
void set_up(Camera *cam, GLfloat uX, GLfloat uY, GLfloat uZ);

void enter_orthographic(float width, float height);
void exit_orthographic();

#endif  */