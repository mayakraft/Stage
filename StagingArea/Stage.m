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
    
    Scene       _scene;
    
//    Screen      *screen;
    
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
    UILabel *titleLabel;
    UILabel *numberLabels[9];
    
    NSArray *hotspots;
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
    
//    screen = [[Screen alloc] initWithFrame:_frame];
    
    navBar = [[NavigationBar alloc] initWithFrame:_frame];
    [navBar setScenePointer:(int*)&_scene];
    
    room = [[Rhombicuboctahedron alloc] init];
    
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
    
    geo = icosahedron(1);
    //65535
    mesh = makeMeshTriangles(&geo, .8333333);
    echoMesh = makeMeshTriangles(&geo, .833333);
    
    makeDiagram(&geo);
    
    camDistance = 2.25;
    start = [NSDate date];
    
    whiteAlpha[0] = whiteAlpha[1] = whiteAlpha[2] = whiteAlpha[3] = 1.0f;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _frame.size.width, 60)];
    [titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:30]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"SCENE 1"];
    [self addSubview:titleLabel];
    
    float arrowWidth = 50;

    for(int i = 0; i < 9; i++){
        numberLabels[i] = [[UILabel alloc] initWithFrame:CGRectMake((_frame.size.width)/12.*(i+1.5), self.frame.size.height-arrowWidth, (_frame.size.width)/12., (_frame.size.width)/12.)];
        [numberLabels[i] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:30]];
        [numberLabels[i] setTextAlignment:NSTextAlignmentCenter];
        [numberLabels[i] setText:[NSString stringWithFormat:@"%d",i+1]];
        [numberLabels[i] setTextColor:[UIColor blackColor]];
        [self addSubview:numberLabels[i]];
    }
    
    hotspots = @[ [NSValue valueWithCGRect:CGRectMake(5, 5, 40, 40)],
                  [NSValue valueWithCGRect:CGRectMake(_frame.size.width-45, 5, 40, 40)],
                  [NSValue valueWithCGRect:CGRectMake(0, _frame.size.height-arrowWidth*2.5, _frame.size.width, arrowWidth*2.5)]];
}

-(void) changeScene:(Scene)newScene{
    _scene = newScene;
    reset_lighting();
    if(_scene == scene1){
        for (int i = 0; i < 9; i++)
            [numberLabels[i] setTextColor:[UIColor blackColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:@"SCENE 1"];
    }else if (_scene == scene2){
        for (int i = 0; i < 9; i++)
            [numberLabels[i] setTextColor:[UIColor whiteColor]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setText:@"SCENE 2"];
    }else if (_scene == scene3){
        for (int i = 0; i < 9; i++){
            [numberLabels[i] setTextColor:[UIColor blackColor]];
            [numberLabels[i] setHidden:NO];
        }
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:@"SCENE 3"];
    }else if (_scene == scene4){
        for (int i = 0; i < 9; i++)
            [numberLabels[i] setHidden:YES];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setText:@"SCENE 4"];
    }
}

-(void) customizeOpenGL{
    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(int i = 0; i < hotspots.count; i++){
        CGRect hotspot = [[hotspots objectAtIndex:i] CGRectValue];
        if(CGRectContainsPoint(hotspot, [(UITouch*)[touches anyObject] locationInView:self])){
            return;
        }
    }
//    if(_scene != scene1)
//        shrinkMeshFaces(&mesh, &geo, 1.0);
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{  }

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for(int i = 0; i < hotspots.count; i++){
        CGRect hotspot = [[hotspots objectAtIndex:i] CGRectValue];
        if(CGRectContainsPoint(hotspot, [(UITouch*)[touches anyObject] locationInView:self])){
            if(i == 0 && _scene > scene1)
                [self changeScene:_scene-1];
            else if(i == 1 && _scene < scene4)
                [self changeScene:_scene+1];
            else if(i == 2){
                int freq = ([[touches anyObject] locationInView:self].x-(self.frame.size.width)/12.*1.5) / ((self.frame.size.width)/12.);
                if(freq < 0) freq = 0;
                if(freq > 8) freq = 8;
                [navBar setRadioBarPosition:freq];
                [self loadNewGeodesic:freq+1];
            }
            return;
        }
    }
}

-(void) loadNewGeodesic:(int)frequency{
    deleteMeshTriangles(&echoMesh);
    
    deleteMeshTriangles(&mesh);
    deleteGeodesic(&geo);
    geo = icosahedron(frequency);
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
    static GLfloat one = 1.0f;
    
    glClearColor(screenColor[0], screenColor[1], screenColor[2], screenColor[3]);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    
    if(_scene == scene3)
        spotlightNoir(screenColor, &one, &one);

    
    glPushMatrix();
    if(_orientToDevice){
        set_position(&camera1, camDistance*_deviceAttitude[2], camDistance*_deviceAttitude[6], camDistance*(-_deviceAttitude[10]));
        set_up(&camera1, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
    }
    frame_shot(&camera1);

    if(_scene == scene4){
        glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, whiteColor);
        [room draw];
    }
    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, zeroColor);
   
//    if(geo.numFaces) geodesicDrawTriangles(&geo);
//    if(geo.numLines) geodesicDrawLines(&geo);
//    if(geo.numPoints) geodesicDrawPoints(&geo);

    if(_scene == scene1)
        rainbow(screenColor, &one, &one);
    else if(_scene == scene2)
        silhouette(screenColor);
    
    if(_scene != scene4)
        if(mesh.numTriangles) geodesicMeshDrawExtrudedTriangles(&mesh);
 
    float scale = 1.0-(elapsedMillis - touchTime)/.50;
    
    if(_scene == scene1)
        rainbow(screenColor, &one, &scale);
    else if(_scene == scene2)
        silhouette(screenColor);
    else if(_scene == scene3){
        glPopMatrix();
        spotlightNoir(screenColor, &one, &scale);
        glPushMatrix();
        if(_orientToDevice){
            set_position(&camera1, camDistance*_deviceAttitude[2], camDistance*_deviceAttitude[6], camDistance*(-_deviceAttitude[10]));
            set_up(&camera1, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
        }
        frame_shot(&camera1);
    }
    
    if(_scene == scene1){
    
    if(touchTime + .5 > elapsedMillis && touchTime < elapsedMillis)
        if(echoMesh.numTriangles)
            geodesicMeshDrawExtrudedTriangles(&echoMesh);

    }
    else{
        // geodesic un-spherizes back into original polyhedra
        // manage 2 geodesic objects. one morphs into the other
        // triangle faces extrude back into sphere with new frequency
    }
    
    
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
