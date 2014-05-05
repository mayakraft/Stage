#ifndef __Camera__
#define __Camera__

#define Z_NEAR 0.1f
#define Z_FAR 100.0f

#include <OpenGLES/ES1/gl.h>

typedef struct camera camera;

struct camera{
    GLfloat     position[3];  // x,y,z of camera lens
    GLfloat     focus[3];     // x,y,z of point on which to focus
    GLfloat     up[3];        // tilt/roll around line of sight
    
    GLfloat     m[16];  // orientation
    
    // for calculating orientation matrix
    float forward[3], side[3], above[3];
};

void frame_shot(camera *cam);
void build_projection_matrix(float x, float y, float w, float h, float FOV);

void set_position(camera *cam, GLfloat pX, GLfloat pY, GLfloat pZ);
void set_focus(camera *cam, GLfloat fX, GLfloat fY, GLfloat fZ);
void set_up(camera *cam, GLfloat uX, GLfloat uY, GLfloat uZ);

void enter_orthographic(float width, float height);
void exit_orthographic();

#endif /* defined(__Camera__) */
