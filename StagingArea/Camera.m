// with help from MESA 3D project
//
#include "Camera.h"
#include <math.h>
#include "noise.c"
#import "StageCommon.h"

@interface Camera (){
    
    GLfloat     position[3];  // x,y,z of camera lens
    GLfloat     focus[3];     // x,y,z of point on which to focus
    GLfloat     up[3];        // tilt/roll around line of sight
    
    float       _fieldOfView;
    float       _aspectRatio;
    float _radius;
}

@end

@implementation Camera


-(id) init{
    self = [super init];
    if(self){
        position[X] = 0.0f; position[Y] = 0.0f; position[Z] = -5.0f;
        focus[X] = 0.0f;    focus[Y] = 0.0f;    focus[Z] = 0.0f;
        up[X] = 0.0f;       up[Y] = 1.0f;       up[Z] = 0.0f;
        _fieldOfView = 45.0f;
        _aspectRatio = 1.0f;
    }
    return self;
}
-(void) dealloc{
    
}

//-(void) setPosition(GLfloat pX, GLfloat pY, GLfloat pZ){
//    position[X] = pX;   position[Y] = pY;   position[Z] = pZ;
//}
//-(void) setFocus(GLfloat fX, GLfloat fY, GLfloat fZ){
//    focus[X] = fX;  focus[Y] = fY;  focus[Z] = fZ;
//}
//-(void) setUp(GLfloat uX, GLfloat uY, GLfloat uZ){
//    up[X] = uX;     up[Y] = uY;     up[Z] = uZ;
//}

-(void) frameShot{
//    if(animation != NULL)
//        (this->*animation)();
    float r, forward[3], side[3], above[3];
    
    forward[0] = focus[X] - position[X];
    forward[1] = focus[Y] - position[Y];
    forward[2] = focus[Z] - position[Z];
    above[0] = up[X];
    above[1] = up[Y];
    above[2] = up[Z];
//    normalize(forward);
    r = sqrt( forward[0]*forward[0] + forward[1]*forward[1] + forward[2]*forward[2] );
    if (r == 0.0) return;
    forward[0] /= r;      forward[1] /= r;      forward[2] /= r;

//    side = forward <cross> above
    side[0] = forward[1]*above[2] - forward[2]*above[1];
    side[1] = forward[2]*above[0] - forward[0]*above[2];
    side[2] = forward[0]*above[1] - forward[1]*above[0];
//    normalize(side);
    r = sqrt( side[0]*side[0] + side[1]*side[1] + side[2]*side[2] );
    if (r == 0.0) return;
    side[0] /= r;      side[1] /= r;      side[2] /= r;

//    above = side <cross> forward
    above[0] = side[1]*forward[2] - side[2]*forward[1];
    above[1] = side[2]*forward[0] - side[0]*forward[2];
    above[2] = side[0]*forward[1] - side[1]*forward[0];

//    velocity = sqrtf( pow(side[0]-m[0],2) + pow(side[1]-m[4],2) + pow(side[2]-m[8],2)
//                     + pow(above[0]-m[1],2) + pow(above[1]-m[5],2) + pow(above[2]-m[9],2)
//                     + pow(-forward[0]-m[2],2) + pow(-forward[1]-m[6],2) + pow(-forward[2]-m[10],2) );
//    m[0] = side[0];     m[1] = above[0];    m[2] = -forward[0];     m[3] = 0.0f;
//    m[4] = side[1];     m[5] = above[1];    m[6] = -forward[1];     m[7] = 0.0f;
//    m[8] = side[2];     m[9] = above[2];    m[10] = -forward[2];    m[11] = 0.0f;
//    m[12] = 0.0f;       m[13] = 0.0f;       m[14] = 0.0f;           m[15] = 1.0f;
    
    _matrix = GLKMatrix4Make(side[0], above[0], -forward[0], 0.0f, side[1], above[1], -forward[1], 0.0f, side[2], above[2], -forward[2], 0.0f, 0.0f, 0.0f, 0.0f, 1.0f);

    glMultMatrixf(_matrix.m);
    glTranslatef(-position[X], -position[Y], -position[Z]);
}

-(void) setAnimation{
    // each animation has a function which relates an input position/focus/up
    // to a set of starting conditions for the variables in the loop
}

-(void) flyToCenter:(float)frame{
    if(frame > 1) frame = 1;
    if(frame < 0) frame = 0;
    _radius = .1+_distanceFromOrigin*(1-frame);
    if(_radius < 1.0) glCullFace(GL_BACK);
    else glCullFace(GL_FRONT);
}

-(void) dollyZoomFlat:(float)frame{
    
    float width = 1;
    float distance = _distanceFromOrigin + frame * 50;
    _radius = distance;
    float fov = 5*atan( width /(2*distance) );
    fov = fov / 3.1415926 * 180.0;
//    NSLog(@"FOV %f",fov);
//    build_projection_matrix(self.frame.origin.x, self.frame.origin.y, (1+IS_RETINA)*self.frame.size.width, (1+IS_RETINA)*self.frame.size.height, fov);
}

// is this going to be a problem that frameNum is static with the same name?
//-(void) animationUpAndDownAndAround{
//    static int frameNum;
//    frameNum++;
//    position[X] = 1.618*sinf(frameNum/100.0);
//    position[Z] = 1.618*cosf(frameNum/100.0);
//    position[Y] = 3*sinf(frameNum/33.0);
//}
//
//-(void) animationPerlinNoiseRotateAround{
//    static int frameNum;
//    frameNum++;
//    static float animAngleVelocity = 0;
//    static float animAngle;
//    animAngleVelocity = noise1(frameNum/200.0) / 1.0;
//    animAngle += animAngleVelocity;
//    position[X] = 1.75*sinf(animAngle);
//    position[Z] = 1.75*cosf(animAngle);
//    position[Y] = 1.25*noise1(frameNum/33.0);
//}
//
//-(void) animationDollyZoom{
//    static float dollyFocus[3] = {0.0f, 0.0f, 0.0f};
//    static int frameNum;
//    frameNum++;
////    position[X] = 1.618*sinf(frameNum2/100.0);
//    position[Z] = 1.618*cosf(frameNum/50.0) + 2.3;
////    position[Y] = sinf(frameNum2/15.0);
//    float width = 1;
//    float distance = sqrtf(pow(position[X]-dollyFocus[X], 2) +
//                           pow(position[Y]-dollyFocus[Y], 2) +
//                           pow(position[Z]-dollyFocus[Z], 2) );
//    float fov = 2*atan( width /(2*distance) );
//    fov = fov / 3.1415926 * 180.0;
//    [self setFieldOfView:fov];
//}

-(void) logOrientation{
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

-(void) setFieldOfView:(float) fieldOfView{
    _fieldOfView = fieldOfView;
    [self rebuildProjectionMatrix];
}
-(void) setAspectRatio:(float) aspectRatio{
    _aspectRatio = aspectRatio;
    [self rebuildProjectionMatrix];
}
-(void) setFrame:(CGRect)frame{
    _frame = frame;
    _aspectRatio = _frame.size.width/_frame.size.height;
    [self rebuildProjectionMatrix];
}

-(void) rebuildProjectionMatrix{
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    GLfloat frustum = Z_NEAR * tanf(_fieldOfView*0.00872664625997);  // pi / 180 / 2
    glFrustumf(-frustum, frustum, -frustum/_aspectRatio, frustum/_aspectRatio, Z_NEAR, Z_FAR);
    glViewport(_frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height);
    glMatrixMode(GL_MODELVIEW);
}

-(void) enterOrthographic{
//    glDisable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glOrthof(0, _frame.size.width, 0, _frame.size.height, -5, 1);   // width and height maybe need to switch
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
}

-(void) exitOrthographic{
    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

@end