#import <OpenGLES/ES1/gl.h>
#import "Stage.h"

//#import "Animation.h"
//#import "Hotspot.h"
//#import "OBJ.h"

//#include "lights.c"

// CUSTOM CLASSES
//#import "SquareRoom.h"
//#import "NavigationScreen.h"

// # SCENES
//typedef enum{
//    scene1,
//    scene2,
//    scene3,
//    scene4,
//    scene5
//} Scene;
//// define all possible kinds of transitions:
//typedef enum{
//    animationNone,
//    animationOrthoToPerspective,  animationPerspectiveToOrtho,
//    animationInsideToPerspective, animationPerspectiveToInside
//} AnimationState;



@interface Stage (){
    CMMotionManager     *motionManager;
    NSDate              *start;
    BOOL                _userInteractionEnabled;

//    AnimationState      cameraAnimationState;
//    
//    // CUSTOMIZE BELOW (get rid of)
//    
//    // ANIMATIONS
//    Animation           *animationTransition;  // triggered by navbar forward/back
//    Animation           *animationNewGeodesic; // triggered by loading new geodesic
//    
//    // CAMERAS
////    Camera              *camera;
//    GLKQuaternion       quaternionFrontFacing;
    BOOL                orientToDevice;
//
//    // OBJECTS
//    OBJ *obj;
//    
//    // ANIMATION TRIGGERS
//    NSArray *hotspots;  // don't overlap hotspots, or re-write touch handling code
}

//@property (nonatomic) int scene;

@property (readonly) NSTimeInterval elapsedSeconds;

@property GLKQuaternion attitude;         // DEVICE ATTITUDE
@property GLKQuaternion orientation;      // WORLD ORIENTATION, can depend or not on device attitude

@property (nonatomic) float *screenColor; // CLEAR SCREEN COLOR

@end

@implementation Stage

+ (instancetype)StageWithNavBar:(Flat*)navBar{
    Stage *stage = [[Stage alloc] init];
    if(stage){
        [stage setFlat:navBar];
    }
    return stage;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    self.preferredFramesPerSecond = 60;
    self.paused = NO;
    
    [view setDelegate:self];
    [view setEnableSetNeedsDisplay:YES];
    [view setOpaque:YES];
    
    [self initOpenGL];
//    [self customizeOpenGL];
    [self setup];
}

-(void)initOpenGL{
    NSLog(@"initOpenGL");
    // iOS environment
    float width, height;
    if([UIApplication sharedApplication].statusBarOrientation > 2){
        width = [[UIScreen mainScreen] bounds].size.height;
        height = [[UIScreen mainScreen] bounds].size.width;
    } else{
        width = [[UIScreen mainScreen] bounds].size.width;
        height = [[UIScreen mainScreen] bounds].size.height;
    }

    float _aspectRatio = width/height;
    float _fieldOfView = 60;
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    GLfloat frustum = Z_NEAR * tanf(GLKMathDegreesToRadians(_fieldOfView) / 2.0);
    glFrustumf(-frustum, frustum, -frustum/_aspectRatio, frustum/_aspectRatio, Z_NEAR, Z_FAR);
    glViewport(0, 0, width, height);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

-(void) setup{
    NSLog(@"setup");
    
    // camera
    //    camera = [[Camera alloc] init];
    //    set_up(&camera, 0, 1, 0);
    //    set_position(&camera, 0, 0, camDistance);
    //    set_focus(&camera, 0, 0, 0);
    //    build_projection_matrix(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height, 58);  // 60
    
//    GLKMatrix4 m = GLKMatrix4MakeLookAt(2.9/*camera.distanceFromOrigin*/, 0, 0, 0, 0, 0, 0, 1, 0);
//    quaternionFrontFacing = GLKQuaternionMakeWithMatrix4(m);
        
//    start = [NSDate date];
//    _userInteractionEnabled = true;
    orientToDevice = true;

    [self initDeviceOrientation];
    
    _screenColor = malloc(sizeof(float)*4);
    
    [self setScreenColor:greenColor];
    
//    [self setRoom:[[SquareRoom alloc] init]];        // TODO: INIT WITH FRAME
//    [self setScreen:[[NavigationScreen alloc] init]];
    

}

//-(void) setScreenColor:(float *)screenColor{
//    set_color(_screenColor, screenColor);
//}
//
//-(void) setScreen:(Screen *)screen{
//    [self.view addSubview:_screen.view];     // add a screen's view or its UI elements won't show
//    [_screen setScene:_scene];
//}
//
//-(void) customizeOpenGL{
//    NSLog(@"customizeOpenGL");
//    glMatrixMode(GL_MODELVIEW);
//    glLoadIdentity();
////    glEnable(GL_CULL_FACE);
////    glCullFace(GL_FRONT);
////    glEnable(GL_DEPTH_TEST);
////    glEnable(GL_BLEND);
////    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//}
//
//-(void) drawRect{
//    static const GLfloat _unit_square[] = {
//        -0.5f, 0.5f, 0.0,
//        0.5f, 0.5f,  0.0,
//        -0.5f, -0.5f,0.0,
//        0.5f, -0.5f, 0.0
//    };
//    glPushMatrix();
//    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
//    glTranslatef(0, 0, 2.0);
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glVertexPointer(3, GL_FLOAT, 0, _unit_square);
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glPopMatrix();
//}

// called before draw function
-(void) update{
    NSLog(@"update");
    _elapsedSeconds = -[start timeIntervalSinceNow];
//    [self animationHandler];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    NSLog(@"drawing");

    glClearColor(_screenColor[0], _screenColor[1], _screenColor[2], _screenColor[3]);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//
//    // lighting independent of rotation
//    //    rainbow(screenColor, &one_f, &one_f);
//    
//    //    glPushMatrix();
//    if(orientToDevice){
//        //        _orientationMatrix = GLKMatrix4MakeLookAt(camera.distanceFromOrigin*_deviceAttitude[2], camera.distanceFromOrigin*_deviceAttitude[6], camera.distanceFromOrigin*(-_deviceAttitude[10]), 0.0f, 0.0f, 0.0f, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
//        //        set_position(&camera, camDistance*_deviceAttitude[2], camDistance*_deviceAttitude[6], camDistance*(-_deviceAttitude[10]));
//        //        set_up(&camera, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
//    }
//    //    frame_shot(&camera);
//    
//    //    _orientationMatrix.m32 = -camera.distanceFromOrigin;
//    
//    //    _orientationMatrix = GLKMatrix4Identity;
//    
//    //    _orientationMatrix = GLKMatrix4MakeWithArray(_deviceAttitude);
//    //    glMultMatrixf(_orientationMatrix.m);
//    
//    //    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, zeroColor);
//    
//    //    GLKMatrix4 m = _orientationMatrix;//GLKMatrix4MakeWithArray(_deviceAttitude);
//    //    NSLog(@"\n%f, %f, %f, %f\n %f, %f, %f, %f\n %f, %f, %f, %f\n %f, %f, %f, %f", m.m00, m.m01, m.m02, m.m03, m.m10, m.m11, m.m12, m.m13, m.m20, m.m21, m.m22, m.m23, m.m30, m.m31, m.m32, m.m33);
//    
//    // lighting rotates with orientation
//    //    rainbow(screenColor, &one_f, &one_f);
//    
//    
////    glMultMatrixf(GLKMatrix4Identity.m);
//    glLoadIdentity();
////    glMultMatrixf(GLKMatrix4MakeWithQuaternion(_attitude).m);
//    
//    //    if(obj)
//    //        [obj draw];
//    
//    glDisable(GL_LIGHTING);
//    glDisable(GL_CULL_FACE);
//    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
//    
//    if(_room)
//        [_room draw];
//    
//    
//    //    glDisable(GL_LIGHTING);
//    //    glDisable(GL_CULL_FACE);
//    //    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
//    //
//    [self drawRect];
//    //
//    //    glPopMatrix();
//    
//    
//    //    if(animationNewGeodesic != nil){
//    //        float scale = 1.0-[animationNewGeodesic scale];  // this is getting called twice,
//    //        rainbow(screenColor, &one_f, &scale);
//    //        // draw more
//    //    }
//    
//    
//    //    if(navScreen)
//    //        [navScreen draw];
//    
}
//-(void) setScene:(int)scene{
//    //    reset_lighting();
//    
//    if(_screen)
//        [_screen setScene:_scene];
//    
//    if(scene == scene1){ }
//    else if (scene == scene2){ }
//    else if (scene == scene3){ }
//    else if (scene == scene4){ }
//    else if (scene == scene5){ }
//    _scene = scene;
//}
//
//-(void) changeCameraAnimationState:(AnimationState) newState{
//    if(newState == animationNone){
//        if(cameraAnimationState == animationOrthoToPerspective){
//            orientToDevice = true;
//        }
//    }
//    else if(newState == animationPerspectiveToOrtho){
////        GLKMatrix4 m = GLKMatrix4Make(_orientationMatrix.m[0], _orientationMatrix.m[1], _orientationMatrix.m[2], _orientationMatrix.m[3],
////                                      _orientationMatrix.m[4], _orientationMatrix.m[5], _orientationMatrix.m[6], _orientationMatrix.m[7],
////                                      _orientationMatrix.m[8], _orientationMatrix.m[9], _orientationMatrix.m[10],_orientationMatrix.m[11],
////                                      _orientationMatrix.m[12],_orientationMatrix.m[13],_orientationMatrix.m[14],_orientationMatrix.m[15]);
//        _orientation = _attitude;
//        orientToDevice = false;
//    }
//    cameraAnimationState = newState;
//}
//
//-(void)animationDidStop:(Animation *)a{
//    if([a isEqual:animationNewGeodesic]){
//        
//    }
//    if([a isEqual:animationTransition]){
//        if(cameraAnimationState == animationOrthoToPerspective) // this stuff could go into the function pointer function
//            orientToDevice = true;
//        cameraAnimationState = animationNone;
//    }
//}
//
//-(void) animationHandler{
//    _elapsedSeconds = -[start timeIntervalSinceNow];
//    
//    // list all animations
//    if(animationNewGeodesic)
//        animationNewGeodesic = [animationNewGeodesic step];
//    if(animationTransition)
//        animationTransition = [animationTransition step];
//    
//    
//    
//    if(animationTransition != nil){
//        
//        float frame = [animationTransition scale];
//        if(frame > 1) frame = 1.0;
//        if(cameraAnimationState == animationPerspectiveToOrtho){
//            GLKQuaternion q = GLKQuaternionSlerp(_attitude, quaternionFrontFacing, powf(frame,2));
//            _orientation = q;
////            [camera dollyZoomFlat:powf(frame,3)];
//        }
//        if(cameraAnimationState == animationOrthoToPerspective){
////            GLKMatrix4 m = GLKMatrix4MakeLookAt(camera.distanceFromOrigin*_deviceAttitude[2], camera.distanceFromOrigin*_deviceAttitude[6], camera.distanceFromOrigin*(-_deviceAttitude[10]), 0.0f, 0.0f, 0.0f, _deviceAttitude[1], _deviceAttitude[5], -_deviceAttitude[9]);
////            GLKQuaternion mtoq = GLKQuaternionMakeWithMatrix4(m);
////            GLKQuaternion q = GLKQuaternionSlerp(quaternionFrontFacing, mtoq, powf(frame,2));
////            _orientationMatrix = GLKMatrix4MakeWithQuaternion(q);
////            [camera dollyZoomFlat:powf(1-frame,3)];
//        }
//        if(cameraAnimationState == animationPerspectiveToInside){
////            [camera flyToCenter:frame];
//        }
//        if(cameraAnimationState == animationInsideToPerspective){
////            [camera flyToCenter:1-frame];
//        }
//    }
//}
//
//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    if(_userInteractionEnabled){
//        for(UITouch *touch in touches){
//            for(Hotspot *spot in hotspots){
//                if(CGRectContainsPoint([spot bounds], [touch locationInView:self.view])){
//                    // customize response to each touch area
//                    if([spot ID] == hotspotBackArrow) { }
//                    if([spot ID] == hotspotForwardArrow) { }
//                    if([spot ID] == hotspotControls) { }
//                    break;
//                }
//            }
//        }
//    }
//}
//
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    if(_userInteractionEnabled){
//        for(UITouch *touch in touches){
//            for(Hotspot *spot in hotspots){
//                if(CGRectContainsPoint([spot bounds], [touch locationInView:self.view])){
//                    // customize response to each touch area
//                    if([spot ID] == hotspotBackArrow) { }
//                    if([spot ID] == hotspotForwardArrow) { }
//                    if([spot ID] == hotspotControls && _scene == scene2){
//                        float freq = ([touch locationInView:self.view].x-(self.view.frame.size.width)/12.*1.5) / ((self.view.frame.size.width)/12.);
//                        if(freq < 0) freq = 0;
//                        if(freq > 8) freq = 8;
//                        //TODO: THIS NEEDS TO GET THE UPDATE
////                        [navScreen setRadioBarPosition:freq];
//                    }
//                    break;
//                }
//            }
//        }
//    }
//}
//
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    if(_userInteractionEnabled){
//        for(UITouch *touch in touches){
//            for(Hotspot *spot in hotspots){
//                if(CGRectContainsPoint([spot bounds], [touch locationInView:self.view])){
//                    // customize response to each touch area
//                    if([spot ID] == hotspotBackArrow && _scene > scene1){
//                        animationTransition = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.2];
//                        if(_scene == scene2)
//                            [self changeCameraAnimationState:animationOrthoToPerspective];
//                        if(_scene == scene5)
//                            [self changeCameraAnimationState:animationInsideToPerspective];
//                        if (_scene-1 == scene3)
//                            [self changeCameraAnimationState:animationPerspectiveToOrtho];
//                        if (_scene-1 == scene5)
//                            [self changeCameraAnimationState:animationPerspectiveToInside];
//                        [self setScene:_scene-1];
//                    }
//                    else if([spot ID] == hotspotForwardArrow && _scene < scene5){
//                        if(_scene == scene3)
//                            [self changeCameraAnimationState:animationOrthoToPerspective];
//                        if(_scene == scene5)
//                            [self changeCameraAnimationState:animationInsideToPerspective];
//                        if (_scene+1 == scene2)
//                            [self changeCameraAnimationState:animationPerspectiveToOrtho];
//                        if (_scene+1 == scene5)
//                            [self changeCameraAnimationState:animationPerspectiveToInside];
//                        animationTransition = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.2];
//                        [self setScene:_scene+1];
//                    }
//                    else if([spot ID] == hotspotControls){
//                        if(_scene == scene1){
//                            if([touch locationInView:self.view].x < self.view.frame.size.width*.5){
//                                
//                            }
//                            else if([touch locationInView:self.view].x > self.view.frame.size.width*.5){
//                                
//                            }
//                        }
//                        if(_scene == scene2){
//                            int freq = ([touch locationInView:self.view].x-(self.view.frame.size.width)/12.*1.5) / ((self.view.frame.size.width)/12.);
//                            if(freq < 0) freq = 0;
//                            if(freq > 8) freq = 8;
//                            //TODO: THIS NEEDS TO GET THE UPDATE
////                            [navScreen setRadioBarPosition:freq];
//                            animationNewGeodesic = [[Animation alloc] initOnStage:self Start:_elapsedSeconds End:_elapsedSeconds+.5];
//                        }
//                    }
//                    break;
//                }
//            }
//        }
//    }
//}














-(void) initDeviceOrientation{
    motionManager = [[CMMotionManager alloc] init];
    if([motionManager isDeviceMotionAvailable]){
        motionManager.deviceMotionUpdateInterval = 1.0f/60.0f;
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
            CMQuaternion q = deviceMotion.attitude.quaternion;
            _attitude = GLKQuaternionMake(q.x, q.y, q.z, q.w);
            NSLog(@".");
        }];
    }
    else{
        _attitude = GLKQuaternionIdentity;
    }
}

- (void)tearDownGL{
    //unload shapes
//    glDeleteBuffers(1, &_vertexBuffer);
//    glDeleteVertexArraysOES(1, &_vertexArray);
    [EAGLContext setCurrentContext:nil];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    NSLog(@"DEALLOC");
//    free(_screenColor);
}

@end
