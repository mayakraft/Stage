#import <OpenGLES/ES1/gl.h>
#import "Stage.h"
#import "OBJ.h"

#include "Lights.h"
#include "Camera.h"

// attach the lights to the orientation matrix
// so the rainbow always hits from a visible angle

@interface Stage (){
    
    float       clearColor[4];
    
    Light       lights;
    
    Camera      camera1;
    GLfloat     *cameraPosition;
    GLfloat     *cameraFocus;
    GLfloat     *cameraUp;
    
    OBJ         *obj;
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

-(void) setupScene{
    
    [self customSetup];

//    // lights
    lights.rainbow(clearColor);
//    lights.silhouette(clearColor);
//    lights.spotlightNoir(clearColor);
    
    // camera
    camera1.setFieldOfView(25);
    camera1.setFrame(_frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height);  // also sets aspect ratio
    camera1.setPosition(0.0f, 0.0f, 5.0f);
    camera1.setFocus(0.0f, 0.0f, 0.0f);
    camera1.animation = &Camera::animationPerlinNoiseRotateAround;  //top of draw loop
    
    // characters
//    obj = [[OBJ alloc] initWithOBJ:@"tetra.obj" Path:[[NSBundle mainBundle] resourcePath]];
    obj = [[OBJ alloc] initWithGeodesic:3 Frequency:arc4random()%6+1];
}

-(void) customSetup{
    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
    glEnable(GL_DEPTH_TEST);
}
-(void)draw{
    
    glClearColor(clearColor[0], clearColor[1], clearColor[2], clearColor[3]);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glPushMatrix();
    camera1.frameShot();
    glScalef(0.25, 0.25, 0.25);
    [obj draw];
    glPopMatrix();
}

-(void) touchesEnded{   }

-(void) tearDownGL{
    //unload shapes
//    glDeleteBuffers(1, &_vertexBuffer);
//    glDeleteVertexArraysOES(1, &_vertexArray);
}

@end
