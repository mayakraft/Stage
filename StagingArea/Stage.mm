#import <OpenGLES/ES1/gl.h>
#import <CoreMotion/CoreMotion.h>
#import "Stage.h"
#import "OBJ.h"

#include "Lights.c"
#include "Camera.h"

// attach the lights to the orientation matrix
// so the rainbow always hits from a visible angle

@interface Stage (){
    
    float       screenColor[4];
    
    Camera      camera1;
    GLfloat     *cameraPosition;
    GLfloat     *cameraFocus;
    GLfloat     *cameraUp;
    
    OBJ         *obj;
    
    GLfloat     _attitudeMatrix[16];
    
    GLfloat     quadVertices[3*4];
    GLfloat     triVertices[3*3];
}

@end

@implementation Stage

-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    if(self){
        _frame = frame;
        [self setupScene];
    }
    return self;
}
-(void)setAttitude:(GLfloat *)attitude{
    for(int i = 0; i < 16; i++)
        _attitudeMatrix[i] = attitude[i];
}
-(void) setupScene{
    
    [self customSetup];

//    // lights
    rainbow(screenColor);
//    silhouette(screenColor);
//    spotlightNoir(screenColor);
    
    // camera
    camera1.setFieldOfView(25);
    camera1.setFrame(_frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height);  // also sets aspect ratio
    camera1.setPosition(0.0f, 0.0f, 5.0f);
    camera1.setFocus(0.0f, 0.0f, 0.0f);
//    camera1.animation = &Camera::animationPerlinNoiseRotateAround;  //top of draw loop
    
    // characters
//    obj = [[OBJ alloc] initWithOBJ:@"tetra.obj" Path:[[NSBundle mainBundle] resourcePath]];
    obj = [[OBJ alloc] initWithGeodesic:3 Frequency:arc4random()%6+1];
    
    [self fillQuad];
    [self fillTri];
    
//    [self initDeviceOrientation];
    
    

}

-(void) customSetup{
    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
    glEnable(GL_DEPTH_TEST);
}
-(void)draw{
    static GLfloat whiteColor[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    static GLfloat clearColor[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    glClearColor(screenColor[0], screenColor[1], screenColor[2], screenColor[3]);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glPushMatrix();
    camera1.setPosition(2*_attitudeMatrix[2], 2*_attitudeMatrix[6], 2*(-_attitudeMatrix[10]));
    camera1.setUp(_attitudeMatrix[1], _attitudeMatrix[5], -_attitudeMatrix[9]);
    camera1.frameShot();
    
    
    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, whiteColor);  // panorama display at full color
    [self drawRoomWalls];
    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, clearColor);
    
//    glMultMatrixf(_attitudeMatrix);
    glScalef(0.25, 0.25, 0.25);
    [obj draw];
    glPopMatrix();
//    [self log];
}

-(void) log{
    static int count = 0;
    count++;
    if(count%60 == 0){
//        GLfloat *proj = &_attitudeMatrix[0];
        
//        glGetFloatv(GL_PROJECTION_MATRIX, proj);
//        for(int i = 0; i < 16; i++){
//            NSLog(@"%f",proj[i]);
//        }
        
        //0rientation matrix
        NSLog(@"\n  [ %.3f, %.3f, %.3f, %.3f ]\n  [ %.3f, %.3f, %.3f, %.3f ]\n  [ %.3f, %.3f, %.3f, %.3f ]\n  [ %.3f, %.3f, %.3f, %.3f ]\n",
              _attitudeMatrix[0], _attitudeMatrix[1], _attitudeMatrix[2], _attitudeMatrix[3],
              _attitudeMatrix[4], _attitudeMatrix[5], _attitudeMatrix[6], _attitudeMatrix[7],
              _attitudeMatrix[8], _attitudeMatrix[9], _attitudeMatrix[10], _attitudeMatrix[11],
              _attitudeMatrix[12], _attitudeMatrix[13], _attitudeMatrix[14], _attitudeMatrix[15]);

//        NSLog(@"\n  ( %.3f, %.3f, %.3f, %.3f )\n",
//              _quaternion[0], _quaternion[1], _quaternion[2], _quaternion[3]);
//        NSLog(@"\n  (P:%.3f R:%.3f Y:%.3f)\n",
//              eulerAngles[0], eulerAngles[1], eulerAngles[2]);
    }
}

-(void)drawRoomWalls{
    glDisable(GL_CULL_FACE);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    static float dist = sqrtf(2)*2;

    glPushMatrix();
    glScalef(1.25, 1.25, 1.25);

// SQUARE FACES
    
    // top and bottom
    glPushMatrix();
        glRotatef(90, 1, 0, 0);
        glTranslatef(0.0f, 0.0f, -dist);
        [self drawQuad];
    glPopMatrix();
    glPushMatrix();
        glRotatef(90, 1, 0, 0);
        glTranslatef(0.0f, 0.0f, dist);
        [self drawQuad];
    glPopMatrix();
    // 4 sides
    glPushMatrix();
        glTranslatef(0.0f, 0.0f, dist);
        [self drawQuad];
    glPopMatrix();
    glPushMatrix();
        glTranslatef(0.0f, 0.0f, -dist);
        [self drawQuad];
    glPopMatrix();
    glPushMatrix();
        glRotatef(90, 0, 1, 0);
        glTranslatef(0.0f, 0.0f, dist);
        [self drawQuad];
    glPopMatrix();
    glPushMatrix();
        glRotatef(90, 0, 1, 0);
        glTranslatef(0.0f, 0.0f, -dist);
        [self drawQuad];
    glPopMatrix();
    
//ROTATION 1
    
    glPushMatrix();
    glRotatef(45, 0, 1, 0);

    // 4 sides
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();

    glPopMatrix();
    
// ROTAITON 2
    glPushMatrix();
    glRotatef(45, 1, 0, 0);
    
    // top and bottom
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    // 4 sides
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();

    glPopMatrix();
    
// ROTATION 3
    glPushMatrix();
    glRotatef(45, 0, 0, 1);
    
    // top and bottom
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    // 4 sides
    // cut
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawQuad];
    glPopMatrix();
    glPushMatrix();
    glRotatef(90, 0, 1, 0);
    glTranslatef(0.0f, 0.0f, -dist);
    [self drawQuad];
    glPopMatrix();
    
    glPopMatrix();
    
    // BOTTOM TRIANGLES
    glPushMatrix();
    glRotatef(45, 0, 1, 0);
    glRotatef(45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    glRotatef(180, 0, 0, 1);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+90, 0, 1, 0);
    glRotatef(45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    glRotatef(180, 0, 0, 1);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+180, 0, 1, 0);
    glRotatef(45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    glRotatef(180, 0, 0, 1);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+270, 0, 1, 0);
    glRotatef(45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    glRotatef(180, 0, 0, 1);
    [self drawTri];
    glPopMatrix();
   
    
    // TOP TRIANGLES
    
    glPushMatrix();
    glRotatef(45, 0, 1, 0);
    glRotatef(-45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+90, 0, 1, 0);
    glRotatef(-45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+180, 0, 1, 0);
    glRotatef(-45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawTri];
    glPopMatrix();
    glPushMatrix();
    glRotatef(45+270, 0, 1, 0);
    glRotatef(-45, 1, 0, 0);
    glTranslatef(0.0f, 0.0f, dist);
    [self drawTri];
    glPopMatrix();

    
    glPopMatrix();  // scale master
    
    

    glEnable(GL_CULL_FACE);
}

-(void) drawQuad{
    glEnableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, quadVertices);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableClientState(GL_VERTEX_ARRAY);
}

-(void) fillQuad{
    quadVertices[0] = -1.0f;    quadVertices[1] = 1.0f;     quadVertices[2] = 0.0f;
    quadVertices[3] = -1.0f;    quadVertices[4] = -1.0f;    quadVertices[5] = 0.0f;
    quadVertices[6] = 1.0f;     quadVertices[7] = 1.0f;     quadVertices[8] = 0.0f;
    quadVertices[9] = 1.0f;     quadVertices[10] = -1.0f;   quadVertices[11] = 0.0f;
}

-(void)drawTri{
    glEnableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, triVertices);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableClientState(GL_VERTEX_ARRAY);
}

-(void) fillTri{
    triVertices[0] = 0.0f;      triVertices[1] = 0.71132486540518*sqrtf(3)/2.;      triVertices[2] = 0.0f;
    triVertices[3] = 1.0f;      triVertices[4] = -0.28867513459482*sqrtf(3)/2.-sqrtf(3)/2.;     triVertices[5] = 0.0f;
    triVertices[6] = -1.0f;     triVertices[7] = -0.28867513459482*sqrtf(3)/2.-sqrtf(3)/2.;     triVertices[8] = 0.0f;
    
    
}

-(void) touchesEnded{   }

-(void) tearDownGL{
    //unload shapes
//    glDeleteBuffers(1, &_vertexBuffer);
//    glDeleteVertexArraysOES(1, &_vertexArray);
}

@end
