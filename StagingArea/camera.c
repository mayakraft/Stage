// with help from MESA 3D project
//
#include "camera.h"
#include <math.h>
#include "noise.c"

static void normalize(float v[3]){
    float r = sqrt( v[0]*v[0] + v[1]*v[1] + v[2]*v[2] );
    if (r == 0.0) return;
    v[0] /= r;      v[1] /= r;      v[2] /= r;
}

static void cross(float v1[3], float v2[3], float result[3]){
    result[0] = v1[1]*v2[2] - v1[2]*v2[1];
    result[1] = v1[2]*v2[0] - v1[0]*v2[2];
    result[2] = v1[0]*v2[1] - v1[1]*v2[0];
}

void frame_shot(camera *cam){
    cam->forward[0] = cam->focus[0] - cam->position[0];
    cam->forward[1] = cam->focus[1] - cam->position[1];
    cam->forward[2] = cam->focus[2] - cam->position[2];
    cam->above[0] = cam->up[0];
    cam->above[1] = cam->up[1];
    cam->above[2] = cam->up[2];
    normalize(cam->forward);
    cross(cam->forward, cam->above, cam->side);
    normalize(cam->side);
    cross(cam->side, cam->forward, cam->above);
//    velocity = sqrtf( pow(side[0]-m[0],2) + pow(side[1]-m[4],2) + pow(side[2]-m[8],2)
//                     + pow(above[0]-m[1],2) + pow(above[1]-m[5],2) + pow(above[2]-m[9],2)
//                     + pow(-forward[0]-m[2],2) + pow(-forward[1]-m[6],2) + pow(-forward[2]-m[10],2) );
    cam->m[0] = cam->side[0];     cam->m[1] = cam->above[0];    cam->m[2] = -cam->forward[0];     cam->m[3] = 0.0f;
    cam->m[4] = cam->side[1];     cam->m[5] = cam->above[1];    cam->m[6] = -cam->forward[1];     cam->m[7] = 0.0f;
    cam->m[8] = cam->side[2];     cam->m[9] = cam->above[2];    cam->m[10] = -cam->forward[2];    cam->m[11] = 0.0f;
    cam->m[12] = 0.0f;            cam->m[13] = 0.0f;            cam->m[14] = 0.0f;                cam->m[15] = 1.0f;
    glMultMatrixf(&cam->m[0]);
    glTranslatef(-cam->position[0], -cam->position[1], -cam->position[2]);
//    logOrientation();
}

void set_position(camera *cam, GLfloat pX, GLfloat pY, GLfloat pZ){
    cam->position[0] = pX;
    cam->position[1] = pY;
    cam->position[2] = pZ;
}
void set_focus(camera *cam, GLfloat fX, GLfloat fY, GLfloat fZ){
    cam->focus[0] = fX;
    cam->focus[1] = fY;
    cam->focus[2] = fZ;
}
void set_up(camera *cam, GLfloat uX, GLfloat uY, GLfloat uZ){
    cam->up[0] = uX;
    cam->up[1] = uY;
    cam->up[2] = uZ;
}

// RESET CAMERA POSITION

void build_projection_matrix(float x, float y, float w, float h, float FOV){
    float aspect = w/h;
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    GLfloat frustum = Z_NEAR * tanf(FOV*0.00872664625997);  // pi / 180 / 2
    glFrustumf(-frustum, frustum, -frustum/aspect, frustum/aspect, Z_NEAR, Z_FAR);
    glViewport(x, y, w, h);
    glMatrixMode(GL_MODELVIEW);
}

void enter_orthographic(float width, float height){
//    glDisable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glOrthof(0, width, 0, height, -5, 1);   // width and height maybe need to switch
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
}

void exit_orthographic(){
    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

