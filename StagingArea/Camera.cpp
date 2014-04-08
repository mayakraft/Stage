//
//  Camera.cpp
//  StagingArea
//
//  Created by Robby on 4/6/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//
///////////////////////////
// with help from MESA 3D project
//

#include "Camera.h"
#include <math.h>

 void normalize(float v[3]){
    float r = sqrt( v[0]*v[0] + v[1]*v[1] + v[2]*v[2] );
    if (r == 0.0) return;
    v[0] /= r;      v[1] /= r;      v[2] /= r;
}
 void cross(float v1[3], float v2[3], float result[3]){
    result[0] = v1[1]*v2[2] - v1[2]*v2[1];
    result[1] = v1[2]*v2[0] - v1[0]*v2[2];
    result[2] = v1[0]*v2[1] - v1[1]*v2[0];
}

void Camera::frameShot(){
    if(animation != NULL)
        animation();
    animationUpAndDownAndAround();
    focus[X] = focus[Y] = focus[Z] = 0.0f;
    forward[0] = focus[X] - position[X];
    forward[1] = focus[Y] - position[Y];
    forward[2] = focus[Z] - position[Z];
    above[0] = up[X];
    above[1] = up[Y];
    above[2] = up[Z];
    normalize(forward);
    cross(forward, above, side);
    normalize(side);
    cross(side, forward, above);
    m[0] = side[0];     m[1] = above[0];    m[2] = -forward[0];     m[3] = 0.0f;
    m[4] = side[1];     m[5] = above[1];    m[6] = -forward[1];     m[7] = 0.0f;
    m[8] = side[2];     m[9] = above[2];    m[10] = -forward[2];    m[11] = 0.0f;
    m[12] = 0.0f;       m[13] = 0.0f;       m[14] = 0.0f;           m[15] = 1.0f;
    glMultMatrixf(&m[0]);
    glTranslatef(-position[X], -position[Y], -position[Z]);
//    logOrientation();
}

void Camera::animationUpAndDownAndAround(){
    static float frameNum;
    frameNum++;
    position[X] = 1.618*sinf(frameNum/100.0);
    position[Z] = 1.618*cosf(frameNum/100.0);
    position[Y] = 3*sinf(frameNum/33.0);
}

void Camera::logOrientation(){
    static int logDelay;
    logDelay++;
    if(logDelay%3 == 0){
    GLfloat model[16];
    glGetFloatv(GL_MODELVIEW_MATRIX, model);
    printf("\n[%.3f, %.3f, %.3f, %.3f]\n[%.3f, %.3f, %.3f, %.3f]\n[%.3f, %.3f, %.3f, %.3f]\n[%.3f, %.3f, %.3f, %.3f]\n",
           model[0], model[4], model[8], model[12], model[1], model[5], model[9], model[13],
           model[2], model[6], model[10], model[14], model[3], model[7], model[11], model[15]);
    }
}

// RESET CAMERA POSITION

void Camera::setFieldOfView(float fieldOfView){
    _fieldOfView = fieldOfView;
    rebuildProjectionMatrix();
}
void Camera::setAspectRatio(float aspectRatio){
    _aspectRatio = aspectRatio;
    rebuildProjectionMatrix();
}
void Camera::setFrame(int width, int height){
    _width = width;
    _height = height;
    rebuildProjectionMatrix();
}
void Camera::rebuildProjectionMatrix(){
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    GLfloat frustum = Z_NEAR * tanf(_fieldOfView*0.00872664625997);  // pi / 180 / 2
    glFrustumf(-frustum, frustum, -frustum/_aspectRatio, frustum/_aspectRatio, Z_NEAR, Z_FAR);
    glViewport(0, 0, _width, _height);
    glMatrixMode(GL_MODELVIEW);
}

///////////////////////////
//
// from the MESA 3D project


// end of MESA 3D
//
///////////////////////////

