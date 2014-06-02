#import <OpenGLES/ES1/gl.h>
#import <CoreMotion/CoreMotion.h>
#import "Stage.h"
#import "Room.h"
#import "Screen.h"

#import "NavigationBar.h"

#include "Camera.c"
#include "lights.c"
#include "geodesic.c"

#import "Rhombicuboctahedron.h"

#import "Animation.h"

//#import "OBJ.h"

#define camHomeDistance 2.25

typedef enum{
    animationNone,
    animationOrthoToPerspective,
    animationPerspectiveToOrtho,
    animationInsideToPerspective,
    animationPerspectiveToInside
} AnimationState;

typedef enum{
    scene1,
    scene2,
    scene3,
    scene4
} Scene;

@interface Stage (){
    
    Scene           scene;
    AnimationState  cameraAnimationState;
    Animation       *animationTransition;  // triggered by navbar forward/back
    Animation       *animationNewGeodesic; // triggered by loading new geodesic
    
//    Screen      *screen;
    
    NavigationBar *navBar;
    
    Room        *room;

    float screenColor[4];

//    OBJ                 *obj;
    geodesic            geo;
    geomeshTriangles    mesh;
    geomeshTriangles    echoMesh;
    geomeshCropPlanes   cropPlanes;
    
    Camera      camera;
    float       camDistance;
    GLKQuaternion orientation, quaternionFrontFacing;
    
    NSDate *start;
    NSTimeInterval timeTouchesBegan, timeTouchesMoved, timeTouchesEnded;
    
    BOOL transitioning;
    BOOL interactionDisabled;
    NSTimeInterval interactionDownTime, interactionDownDuration;
    
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
    
    navBar = [[NavigationBar alloc] initWithFrame:_frame];
    [navBar setScenePointer:(int*)&scene];

    room = [[Rhombicuboctahedron alloc] init];
    
    // camera
    camDistance = camHomeDistance;
    set_up(&camera, 0, 1, 0);
    set_position(&camera, 0, 0, camDistance);
    set_focus(&camera, 0, 0, 0);
    build_projection_matrix(_frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height, 58);  // 60
    
    GLKMatrix4 m = GLKMatrix4MakeLookAt(camDistance, 0, 0, 0, 0, 0, 0, 1, 0);
    quaternionFrontFacing = GLKQuaternionMakeWithMatrix4(m);
    
    geo = icosahedron(1);
    //65535
    mesh = makeMeshTriangles(&geo, .8333333);
    echoMesh = makeMeshTriangles(&geo, .833333);
    cropPlanes = makeMeshCropPlanes(&geo);
    
    whiteAlpha[0] = whiteAlpha[1] = whiteAlpha[2] = whiteAlpha[3] = 1.0f;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _frame.size.width, _frame.size.width*.18)];
    [titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:_frame.size.width*.1]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"SCENE 1"];
    [self addSubview:titleLabel];
    
    float arrowWidth = _frame.size.width*.125;

    for(int i = 0; i < 9; i++){
        numberLabels[i] = [[UILabel alloc] initWithFrame:CGRectMake((_frame.size.width)/12.*(i+1.5), self.frame.size.height-arrowWidth, (_frame.size.width)/12., (_frame.size.width)/12.)];
        [numberLabels[i] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:_frame.size.width*.1]];
        [numberLabels[i] setTextAlignment:NSTextAlignmentCenter];
        [numberLabels[i] setText:[NSString stringWithFormat:@"%d",i+1]];
        [numberLabels[i] setTextColor:[UIColor blackColor]];
        [self addSubview:numberLabels[i]];
    }
    [titleLabel setTextColor:[UIColor whiteColor]];
    
    hotspots = @[ [NSValue valueWithCGRect:CGRectMake(5, 5, arrowWidth, arrowWidth)],
                  [NSValue valueWithCGRect:CGRectMake(_frame.size.width-(arrowWidth+5), 5, arrowWidth, arrowWidth)],
                  [NSValue valueWithCGRect:CGRectMake(0, _frame.size.height-arrowWidth*2.5, _frame.size.width, arrowWidth*2.5)]];
    
    start = [NSDate date];
}
-(void) changeScene:(Scene)newScene{
//    reset_lighting();
    if(newScene == scene1){
//        for (int i = 0; i < 9; i++)
//            [numberLabels[i] setTextColor:[UIColor blackColor]];
//        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:@"SCENE 1"];
    }else if (newScene == scene2){
        set_position(&camera, camDistance, 0, 0);
        set_up(&camera, 0, 1, 0);
//        for (int i = 0; i < 9; i++)
//            [numberLabels[i] setTextColor:[UIColor whiteColor]];
//        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setText:@"SCENE 2"];
    }else if (newScene == scene3){
        for (int i = 0; i < 9; i++){
//            [numberLabels[i] setTextColor:[UIColor blackColor]];
            [numberLabels[i] setHidden:NO];
        }
//        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:@"SCENE 3"];
    }else if (newScene == scene4){
        _orientToDevice = true;
        for (int i = 0; i < 9; i++)
            [numberLabels[i] setHidden:YES];
//        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setText:@"SCENE 4"];
    }
    scene = newScene;
}

-(void) changeCameraAnimationState:(AnimationState) newState{
    if(newState == animationNone){
        if(cameraAnimationState == animationOrthoToPerspective){
            _orientToDevice = true;
        }
    }
    else if(newState == animationPerspectiveToOrtho){
        GLKMatrix4 m = GLKMatrix4Make(_orientationMatrix.m[0], _orientationMatrix.m[1], _orientationMatrix.m[2], _orientationMatrix.m[3],
                                      _orientationMatrix.m[4], _orientationMatrix.m[5], _orientationMatrix.m[6], _orientationMatrix.m[7],
                                      _orientationMatrix.m[8], _orientationMatrix.m[9], _orientationMatrix.m[10], _orientationMatrix.m[11],
                                      _orientationMatrix.m[12], _orientationMatrix.m[13], _orientationMatrix.m[14], _orientationMatrix.m[15]);
        orientation = GLKQuaternionMakeWithMatrix4(m);
        _orientToDevice = false;
    }
    cameraAnimationState = newState;
}

-(void) animationFrame{
// list all animations
    
    if(animationNewGeodesic != nil){
//        animationNewGeodesic->animate(self, animationNewGeodesic, elapsedSeconds);
        // this is getting called twice
        float frame = [animationNewGeodesic scale]/12.;
        frame = sqrtf(frame)*.25;
        extrudeTriangles(&echoMesh, &geo, frame);
        if(animationNewGeodesic.endTime < _elapsedSeconds){
//            free(animationNewGeodesic);
            animationNewGeodesic = nil;
        }
    }
    
    if(animationTransition != nil){
//        animationTransition->animate(self, animationTransition, elapsedSeconds);
        float frame = [animationTransition scale];
        if(frame > 1) frame = 1.0;
        if(cameraAnimationState == animationPerspectiveToOrtho){
            GLKQuaternion q = GLKQuaternionSlerp(orientation, quaternionFrontFacing, powf(frame,2));
            _orientationMatrix = GLKMatrix4MakeWithQuaternion(q);
            [self dollyZoomFlat:powf(frame,3)];
        }
        if(cameraAnimationState == animationOrthoToPerspective){
            GLKMatrix4 m = GLKMatrix4MakeLookAt(camDistance*_deviceAttitude[2], camDistance*_deviceAttitude[6], camDistance*(-_deviceAttitude[10]), 0.0f, 0.0f, 0.0f, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
            GLKQuaternion mtoq = GLKQuaternionMakeWithMatrix4(m);
            GLKQuaternion q = GLKQuaternionSlerp(quaternionFrontFacing, mtoq, powf(frame,2));
            _orientationMatrix = GLKMatrix4MakeWithQuaternion(q);
            [self dollyZoomFlat:powf(1-frame,3)];
        }
        if(cameraAnimationState == animationPerspectiveToInside){
            [self flyToCenter:frame];
        }
        if(cameraAnimationState == animationInsideToPerspective){
            [self flyToCenter:1-frame];
        }
        
        if(animationTransition.endTime < _elapsedSeconds){  // this stuff could go into the function pointer function
            if(cameraAnimationState == animationOrthoToPerspective)
                _orientToDevice = true;
            cameraAnimationState = animationNone;
//            free(animationTransition);
            animationTransition = nil;
        }
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
    if(!interactionDisabled){
        for(int i = 0; i < hotspots.count; i++){
            CGRect hotspot = [[hotspots objectAtIndex:i] CGRectValue];
            if(CGRectContainsPoint(hotspot, [(UITouch*)[touches anyObject] locationInView:self])){
                break;
            }
        }
//    if(_scene != scene1)
//        shrinkMeshFaces(&mesh, &geo, 1.0);

//TODO: does this need to be?
        timeTouchesBegan = _elapsedSeconds;
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!interactionDisabled){
        for(int i = 0; i < hotspots.count; i++){
            CGRect hotspot = [[hotspots objectAtIndex:i] CGRectValue];
            if(CGRectContainsPoint(hotspot, [(UITouch*)[touches anyObject] locationInView:self])){
                if(i == 2 && scene != scene4){
                    float freq = ([[touches anyObject] locationInView:self].x-(self.frame.size.width)/12.*1.5) / ((self.frame.size.width)/12.);
                    if(freq < 0) freq = 0;
                    if(freq > 8) freq = 8;
                    [navBar setRadioBarPosition:freq];
                }
                break;
            }
        }
        timeTouchesMoved = _elapsedSeconds;
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!interactionDisabled){
        for(int i = 0; i < hotspots.count; i++){
            CGRect hotspot = [[hotspots objectAtIndex:i] CGRectValue];
            if(CGRectContainsPoint(hotspot, [(UITouch*)[touches anyObject] locationInView:self])){
                if(i == 0 && scene > scene1){
                    animationTransition = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.2];
//                    animationTransition = makeAnimation(elapsedSeconds, elapsedSeconds+.25, logAnimation);
                    if(scene == scene2)
                        [self changeCameraAnimationState:animationOrthoToPerspective];
                    if(scene == scene4)
                        [self changeCameraAnimationState:animationInsideToPerspective];
                    if (scene-1 == scene2)
                        [self changeCameraAnimationState:animationPerspectiveToOrtho];
                    if (scene-1 == scene4)
                        [self changeCameraAnimationState:animationPerspectiveToInside];
                    [self changeScene:scene-1];
                }
                else if(i == 1 && scene < scene4){
                    if(scene == scene2)
                        [self changeCameraAnimationState:animationOrthoToPerspective];
                    if(scene == scene4)
                        [self changeCameraAnimationState:animationInsideToPerspective];
                    if (scene+1 == scene2)
                        [self changeCameraAnimationState:animationPerspectiveToOrtho];
                    if (scene+1 == scene4)
                        [self changeCameraAnimationState:animationPerspectiveToInside];
//                    animationTransition = makeAnimation(elapsedSeconds, elapsedSeconds+.25, logAnimation);
                    animationTransition = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.2];
                    [self changeScene:scene+1];
                }
                else if(i == 2 && scene != scene4){
                    int freq = ([[touches anyObject] locationInView:self].x-(self.frame.size.width)/12.*1.5) / ((self.frame.size.width)/12.);
                    if(freq < 0) freq = 0;
                    if(freq > 8) freq = 8;
                    [navBar setRadioBarPosition:freq];
                    [self loadNewGeodesic:freq+1];
//                    animationNewGeodesic = makeAnimation(elapsedSeconds, elapsedSeconds+.5, animateNewGeodesic);
                    animationNewGeodesic = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.5];
                }
                break;
            }
        }
        timeTouchesEnded = _elapsedSeconds;
    }
}

-(void) loadNewGeodesic:(int)frequency{
    deleteCropPlanes(&cropPlanes);
    deleteMeshTriangles(&echoMesh);
    
    deleteMeshTriangles(&mesh);
    deleteGeodesic(&geo);
    geo = icosahedron(frequency);
    mesh = makeMeshTriangles(&geo, .8333333);
    cropPlanes = makeMeshCropPlanes(&geo);
    
    echoMesh = makeMeshTriangles(&geo, .833333);
}

-(void) flyToCenter:(float)frame{
    if(frame > 1) frame = 1;
    if(frame < 0) frame = 0;
    camDistance = .1+camHomeDistance*(1-frame);
    if(camDistance < 1.0) glCullFace(GL_BACK);
    else glCullFace(GL_FRONT);
}


-(void) dollyZoomFlat:(float)frame{

    float width = 1;
    float distance = camHomeDistance + frame * 50;
    camDistance = distance;
    float fov = 5*atan( width /(2*distance) );
    fov = fov / 3.1415926 * 180.0;
//    NSLog(@"FOV %f",fov);
    build_projection_matrix(_frame.origin.x, _frame.origin.y, 2*_frame.size.width, 2*_frame.size.height, fov);
}

-(void)draw{
    _elapsedSeconds = -[start timeIntervalSinceNow];
    
    [self animationFrame];
    
    glClearColor(screenColor[0], screenColor[1], screenColor[2], screenColor[3]);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    
    static GLfloat one = 1.0f;
//    if(scene == scene3)
//        spotlightNoir(screenColor, &one, &one);

    
    glPushMatrix();
    if(_orientToDevice){
        _orientationMatrix = GLKMatrix4MakeLookAt(camDistance*_deviceAttitude[2], camDistance*_deviceAttitude[6], camDistance*(-_deviceAttitude[10]), 0.0f, 0.0f, 0.0f, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
//        set_position(&camera, camDistance*_deviceAttitude[2], camDistance*_deviceAttitude[6], camDistance*(-_deviceAttitude[10]));
//        set_up(&camera, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
    }
//    frame_shot(&camera);
    
    _orientationMatrix.m32 = -camDistance;
    glMultMatrixf(_orientationMatrix.m);

//    if(scene == scene4){
//        glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, whiteColor);
//        [room draw];
//    }
    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, zeroColor);

//    if(scene != scene4)
        rainbow(screenColor, &one, &one);
//    else
//        silhouette(screenColor);
    
//    if(scene == scene1)
//        rainbow(screenColor, &one, &one);
//    else if(scene == scene2)
//        silhouette(screenColor);
    
//    if(geo.numFaces) geodesicDrawTriangles(&geo);
//    if(geo.numLines) geodesicDrawLines(&geo);
//    if(geo.numPoints) geodesicDrawPoints(&geo);
//    if(scene != scene4){
//        if(cropPlanes.numPlanes) geodesicMeshDrawCropPlanes(&cropPlanes);
    if(mesh.numTriangles)
        geodesicMeshDrawExtrudedTriangles(&mesh);
//    }
    if(animationNewGeodesic != nil){
 
        float scale = 1.0-[animationNewGeodesic scale];  // this is getting called twice,

        rainbow(screenColor, &one, &scale);

//        if(scene == scene1)
//            rainbow(screenColor, &one, &scale);
//        else if(scene == scene2)
//            silhouette(screenColor);
//        else if(scene == scene3){
//            glPopMatrix();
//            spotlightNoir(screenColor, &one, &scale);
//            glPushMatrix();
//            if(_orientToDevice){
//                set_position(&camera, camDistance*_deviceAttitude[2], camDistance*_deviceAttitude[6], camDistance*(-_deviceAttitude[10]));
//                set_up(&camera, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
//            }
//            frame_shot(&camera);
//        }
        
        if(scene != scene4){
            if(echoMesh.numTriangles)
                geodesicMeshDrawExtrudedTriangles(&echoMesh);
        }
        else{
            // geodesic un-spherizes back into original polyhedra
            // manage 2 geodesic objects. one morphs into the other
            // triangle faces extrude back into sphere with new frequency
        }
    }
    
    if(navBar){
        glDisable(GL_CULL_FACE);
        [navBar draw];
        glEnable(GL_CULL_FACE);
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

    glPopMatrix();
}

-(void) tearDownGL{
    //unload shapes
//    glDeleteBuffers(1, &_vertexBuffer);
//    glDeleteVertexArraysOES(1, &_vertexArray);
}

@end

//NSLog(@"\n%f, %f, %f, %f\n %f, %f, %f, %f\n %f, %f, %f, %f\n %f, %f, %f, %f", m.m00, m.m01, m.m02, m.m03, m.m10, m.m11, m.m12, m.m13, m.m20, m.m21, m.m22, m.m23, m.m30, m.m31, m.m32, m.m33);

