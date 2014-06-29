#import "Stage.h"

void set_color(float* color, float* color_ref){
    color[0] = color_ref[0];
    color[1] = color_ref[1];
    color[2] = color_ref[2];
    color[3] = color_ref[3];
}

@interface Stage (){
    
    NSDate      *start;
    BOOL        orientToDevice;
    BOOL        _userInteractionEnabled;
    float       _aspectRatio;
    float       _fieldOfView;

    CMMotionManager *motionManager;
}

@property (readonly)  NSTimeInterval elapsedSeconds;
//@property (nonatomic) GLKQuaternion  deviceAttitude;
@property (nonatomic) GLKQuaternion  orientation;      // WORLD ORIENTATION, can depend or not on device attitude
@property (nonatomic) GLKMatrix4     deviceAttitude;

@end

@implementation Stage

// INITIALIZERS

+(instancetype)StageWithNavBar:(Flat*)navBar{
    Stage *stage = [[Stage alloc] init];
    if(stage){
        [stage setFlat:navBar];
        [stage setup];
    }
    return stage;
}

+(instancetype)StageWithRoom:(Room*)room{
    Stage *stage = [[Stage alloc] init];
    if(stage){
        [stage setRoom:room];
        [stage setup];
    }
    return stage;
}

// STARTUP

-(void) setup{
    NSLog(@"setup");
    start = [NSDate date];
    _userInteractionEnabled = true;
    orientToDevice = true;
    _backgroundColor = malloc(sizeof(float)*4);
    [self initDeviceOrientation];
}

// OMG cannot subclass viewDidLoad now, cause this is important
-(void)viewDidLoad{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    // SETUP GLKVIEW
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    self.preferredFramesPerSecond = 60;
    
    [self initOpenGL];
    [self customizeOpenGL];
}

-(void)initOpenGL{
    NSLog(@"initOpenGL");

    float width, height;
    if([UIApplication sharedApplication].statusBarOrientation > 2){
        width = [[UIScreen mainScreen] bounds].size.height;
        height = [[UIScreen mainScreen] bounds].size.width;
    } else{
        width = [[UIScreen mainScreen] bounds].size.width;
        height = [[UIScreen mainScreen] bounds].size.height;
    }

    _aspectRatio = width/height;
    _fieldOfView = 60;
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    GLfloat frustum = Z_NEAR * tanf(GLKMathDegreesToRadians(_fieldOfView) / 2.0);
    glFrustumf(-frustum, frustum, -frustum/_aspectRatio, frustum/_aspectRatio, Z_NEAR, Z_FAR);
    glViewport(0, 0, width, height);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
//    GLKMatrix4 m = GLKMatrix4MakeLookAt(2.9/*camera.distanceFromOrigin*/, 0, 0, 0, 0, 0, 0, 1, 0);
//    quaternionFrontFacing = GLKQuaternionMakeWithMatrix4(m);
}

-(void) customizeOpenGL{
    NSLog(@"customizeOpenGL");
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
//    glEnable(GL_CULL_FACE);
//    glCullFace(GL_FRONT);
//    glEnable(GL_DEPTH_TEST);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

-(void) initDeviceOrientation{
    NSLog(@"initDeviceOrientation");
    motionManager = [[CMMotionManager alloc] init];
    if([motionManager isDeviceMotionAvailable]){
        motionManager.deviceMotionUpdateInterval = 1.0f/60.0f;
        [motionManager startDeviceMotionUpdates];
    }
    else{
//        _deviceAttitude = GLKQuaternionIdentity;
        _deviceAttitude = GLKMatrix4Identity;
    }
}


// SETTERS

-(void) setBackgroundColor:(float *)backgroundColor{
    set_color(_backgroundColor, backgroundColor);
}

-(void) setFlat:(Flat *)flat{
    _flat = flat;
    [self.view addSubview:_flat.view];     // add a screen's view or its UI elements won't show
//    [_flat setScene:_scene];
}

// called before draw function
-(void) update{

    _elapsedSeconds = -[start timeIntervalSinceNow];
//    [self animationHandler];
    
    if([motionManager isDeviceMotionAvailable]){
        CMRotationMatrix m = motionManager.deviceMotion.attitude.rotationMatrix;
        _deviceAttitude = GLKMatrix4MakeLookAt(m.m31, m.m32, m.m33, 0, 0, 0, m.m21, m.m22, m.m23);
    }
}

-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect{

    glClearColor(_backgroundColor[0], _backgroundColor[1], _backgroundColor[2], _backgroundColor[3]);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    GLfloat frustum = Z_NEAR * tanf(GLKMathDegreesToRadians(_fieldOfView) / 2.0);
    glFrustumf(-frustum, frustum, -frustum/_aspectRatio, frustum/_aspectRatio, Z_NEAR, Z_FAR);

    glMatrixMode(GL_MODELVIEW);

    glLoadIdentity();
    glPushMatrix();
    
    if(orientToDevice)
        glMultMatrixf(_deviceAttitude.m);
    
    glDisable(GL_LIGHTING);
    glDisable(GL_CULL_FACE);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    if(_room)
        [_room draw];
    
    if(_flat)
        [_flat draw];
    
    glPopMatrix();
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
