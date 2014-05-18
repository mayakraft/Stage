#import <OpenGLES/ES1/gl.h>
#import <CoreMotion/CoreMotion.h>
#import "Stage.h"
#import "Room.h"
#import "Screen.h"

#import "NavigationBar.h"

//#import "OBJ.h"

#include "lights.c"
#include "camera.c"
#include "geodesic.c"

#import "Rhombicuboctahedron.h"

// attach the lights to the orientation matrix
// so the rainbow always hits from a visible angle

typedef enum{
    scene1,
    scene2,
    scene3,
    scene4
} Scene;

@interface Stage (){
    
    Scene       scene;
    
    Screen      *screen;
    
    NavigationBar *navBar;
    
    Room        *room;
    camera      camera1;
    GLfloat     *cameraPosition;
    GLfloat     *cameraFocus;
    GLfloat     *cameraUp;

    float screenColor[4];

//    OBJ                 *obj;
    geodesic            geo;
    geomeshTriangles    mesh;
    geomeshTriangles    echoMesh;
    float camDistance;
    
    NSDate *start;
    NSTimeInterval elapsedMillis;
    NSTimeInterval touchTime;
    
    float whiteAlpha[4];
}

@end

@implementation Stage

- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)context
{
    self = [super initWithFrame:frame context:context];
    if (self) {
        _frame = frame;
        [self setup];
    }
    return self;
}

-(void) setup{
    [self customizeOpenGL];
    
    screen = [[Screen alloc] initWithFrame:_frame];
    
    navBar = [[NavigationBar alloc] initWithFrame:_frame];
    
//    room = [[Rhombicuboctahedron alloc] init];
    
    float brightness = 0.8f;
    float alpha = 1.0f;
    rainbow(screenColor, &brightness, &alpha);
//    silhouette(screenColor);
//    spotlightNoir(screenColor);
    
    // camera
    set_up(&camera1, 0, 1, 0);
    set_position(&camera1, 0, 0, 3);
    set_focus(&camera1, 0, 0, 0);
    build_projection_matrix(_frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height, 60);
//    camera1.animation = &Camera::animationPerlinNoiseRotateAround;  //top of draw loop

    
//        obj = [[OBJ alloc] initWithOBJ:@"tetra.obj" Path:[[NSBundle mainBundle] resourcePath]];
//        obj = [[OBJ alloc] initWithGeodesic:3 Frequency:arc4random()%6+1];
    
    geo = icosahedron(3);
    //65535
    mesh = makeMeshTriangles(&geo, .8333333);
    echoMesh = makeMeshTriangles(&geo, .833333);
    
    makeDiagram(&geo);
    
    camDistance = 2.25;
    start = [NSDate date];
    
    whiteAlpha[0] = whiteAlpha[1] = whiteAlpha[2] = whiteAlpha[3] = 1.0f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _frame.size.width, 60)];
    [label setFont:[UIFont systemFontOfSize:30]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"TITLE"];
    [self addSubview:label];
}

-(void) customizeOpenGL{
    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

-(void) touchesBegan{   }

-(void) touchesMoved{   }

-(void) touchesEnded{
    deleteMeshTriangles(&echoMesh);
    
    deleteMeshTriangles(&mesh);
    deleteGeodesic(&geo);
    geo = icosahedron(arc4random()%10+1);
    mesh = makeMeshTriangles(&geo, .8333333);

    echoMesh = makeMeshTriangles(&geo, .833333);
    touchTime = elapsedMillis;
}

-(void)draw{
    // a device oriented push/pop section
    
    // a non statically oriented push/pop section
    
    elapsedMillis = -[start timeIntervalSinceNow];
    if(touchTime + .5 > elapsedMillis && touchTime < elapsedMillis){
        float scale = (elapsedMillis - touchTime)/6.0;
        scale = sqrtf(scale)*.25;
        extrudeTriangles(&echoMesh, &geo, scale);
    }
    static GLfloat whiteColor[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    static GLfloat noColor[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    glClearColor(screenColor[0], screenColor[1], screenColor[2], screenColor[3]);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glPushMatrix();
    if(_orientToDevice){
        set_position(&camera1, camDistance*_deviceAttitude[2], camDistance*_deviceAttitude[6], camDistance*(-_deviceAttitude[10]));
        set_up(&camera1, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
    }
    frame_shot(&camera1);

    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, whiteColor);
//    [room draw];
    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, noColor);

    float one = 1.0f;
    
    rainbow(screenColor, &one, &one);

    
//    static GLfloat blueColor[] = {0.0f, 0.0f, 1.0f, .50f};
//    static GLfloat greenColor[] = {0.0f, 1.0f, 0.2f, .50f};
//    static GLfloat redColor[] = {1.0f, 0.2f, 0.0f, .50f};
//    float no_mat[4] = {0.0f, 0.0f, 0.0f, 1.0f};
//    float mat_ambient[4] = {0.7f, 0.7f, 0.7f, 1.0f};
//    float mat_ambient_color[4] = {0.8f, 0.8f, 0.2f, 1.0f};
//    float mat_diffuse[4] = {0.1f, 0.5f, 0.8f, 1.0f};
//    float mat_specular[4] = {1.0f, 1.0f, 1.0f, 1.0f};
//    float no_shininess = 0.0f;
//    float low_shininess = 5.0f;
//    float high_shininess = 100.0f;
//    float mat_emission[4] = {0.3f, 0.2f, 0.2f, 0.0f};
    
//    if(geo.numFaces) geodesicDrawTriangles(&geo);
//    if(geo.numLines) geodesicDrawLines(&geo);
//    if(geo.numPoints) geodesicDrawPoints(&geo);


    if(mesh.numTriangles) geodesicMeshDrawExtrudedTriangles(&mesh);
 
    float scale = 1.0-(elapsedMillis - touchTime)/.50;
    rainbow(screenColor, &one, &scale);
    
    if(touchTime + .5 > elapsedMillis && touchTime < elapsedMillis)
        if(echoMesh.numTriangles)
            geodesicMeshDrawExtrudedTriangles(&echoMesh);

//    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, redColor);
//    if(mesh.numVertexNormals)
//        geodesicMeshDrawVertexNormalLines(&mesh);
//    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, greenColor);
//    if(mesh.numLineNormals)
//        geodesicMeshDrawLineNormalLines(&mesh);
//    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, blueColor);
//    if(mesh.numFaceNormals)
//        geodesicMeshDrawFaceNormalLines(&mesh);

//    [obj draw];
    
    
//    if(screen)
//        [screen draw];
    
    if(navBar)
        [navBar draw];
    
    // elevation points
    
//    glDisable(GL_LIGHTING);
//    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, whiteColor);
//    
//    glPushMatrix();
//    glScalef(.002, .002*.5, .002);
//    glTranslatef(-500, 0, -500);
//    glTranslatef(200, 600, 0);
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glVertexPointer(3, GL_FLOAT, 0, data);
//    glDrawArrays(GL_POINTS, 0, 100*100);
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glPopMatrix();


    glPopMatrix();
}

-(void) tearDownGL{
    //unload shapes
//    glDeleteBuffers(1, &_vertexBuffer);
//    glDeleteVertexArraysOES(1, &_vertexArray);
}

@end
