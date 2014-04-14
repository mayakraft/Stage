#import <OpenGLES/ES1/gl.h>
#import "Stage.h"
#import "Camera.h"

#import "OBJ.h"

// attach the lights to the orientation matrix
// so the rainbow always hits from a visible angle

@interface Stage (){
    
    GLfloat     backgroundColor[4];
    
    Camera      camera;
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
        
        // lights
        backgroundColor[0] = backgroundColor[1] = backgroundColor[2] = backgroundColor[3] = 1.0f;
        [self customizeOpenGL];
//        [self lightsSilhouette];
//        [self lightsSpotlightNoir];
        [self lightsRainbow];
        
        // camera
        camera.setFieldOfView(25);
        camera.setFrame(frame.origin.x, frame.origin.y,frame.size.width, frame.size.height);  // also sets aspect ratio
        camera.setPosition(0.0f, 0.0f, 5.0f);
        camera.setFocus(0.0f, 0.0f, 0.0f);
        camera.animation = &Camera::animationPerlinNoiseRotateAround;  //top of draw loop

        // characters
//        obj = [[OBJ alloc] initWithOBJ:@"tetra.obj" Path:[[NSBundle mainBundle] resourcePath]];
        obj = [[OBJ alloc] initWithGeodesic:3 Frequency:arc4random()%6+1];
    }
    return self;
}

-(void) touchesEnded{   }

-(void)draw{
    glClearColor(backgroundColor[0], backgroundColor[1], backgroundColor[2], backgroundColor[3]);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glPushMatrix();
    camera.frameShot();
    glScalef(0.25, 0.25, 0.25);
    [obj draw];
    glPopMatrix();
}

-(void) customizeOpenGL{
    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
    glEnable(GL_DEPTH_TEST);
}

-(void)lightsRainbow{
    backgroundColor[0] = backgroundColor[1] = backgroundColor[2] = 0.0f;
    backgroundColor[3] = 1.0f;
    GLfloat white[] = {.3f, .3f, .3f, 1.0f};
    GLfloat blue[] = {0.0f, 0.0f, 1.0f, 1.0f};
    GLfloat green[] = {0.0f, 1.0f, 0.0f, 1.0f};
    GLfloat red[] = {1.0f, 0.0f, 0.0f, 1.0f};
    GLfloat pos1[] = {0.0f, 10.0f, 0.0f, 1.0f};
    GLfloat pos2[] = {-8.6f, -5.0f, 0.0f, 1.0f};
    GLfloat pos3[] = {8.6f, -5.0f,  0.0f, 1.0f};
    glLightfv(GL_LIGHT1, GL_POSITION, pos1);
    glLightfv(GL_LIGHT1, GL_DIFFUSE, blue);
    glLightfv(GL_LIGHT2, GL_POSITION, pos2);
    glLightfv(GL_LIGHT2, GL_DIFFUSE, red);
    glLightfv(GL_LIGHT3, GL_POSITION, pos3);
    glLightfv(GL_LIGHT3, GL_DIFFUSE, green);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, white);
    glShadeModel(GL_SMOOTH);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT1);
    glEnable(GL_LIGHT2);
    glEnable(GL_LIGHT3);
}

-(void) lightsSpotlightNoir{
    backgroundColor[0] = backgroundColor[1] = backgroundColor[2] = 0.0f;
    backgroundColor[3] = 1.0f;
    GLfloat white[] = {.3f, .3f, .3f, 1.0f};
    GLfloat pos1[] = {0.0f, 10.0f, 0.0f, 1.0f};
    glLightfv(GL_LIGHT0, GL_DIFFUSE, white);
    glLightfv(GL_LIGHT0, GL_POSITION, pos1);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, white);
    glShadeModel(GL_SMOOTH);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
}

-(void) lightsSilhouette{
    backgroundColor[0] = backgroundColor[1] = backgroundColor[2] = backgroundColor[3] = 1.0f;
    glDisable(GL_LIGHTING);
    glColor4f(0.0, 0.0, 0.0, 1.0);
}

@end
