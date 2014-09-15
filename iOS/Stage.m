#import "Stage.h"

#import "SWRevealViewController.h"

// examples
#import "CubeOctaRoom.h"

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

-(void) endTransitionFrom:(unsigned short)fromScene To:(unsigned short)toScene{
    
}

-(void) beginTransitionFrom:(unsigned short)fromScene To:(unsigned short)toScene{
    
}

-(id) init{
    self = [super init];
    if(self){
        [self setup];
        
        // CUSTOMIZE HERE
        
        NavBar *navBar = [[NavBar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height*.15)];
        [navBar setDelegate:self];
        [self addCurtain:navBar];
        
        [self addRoom:[CubeOctaRoom room]];
        [self setBackgroundColor:whiteColor];
    }
    return self;
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

    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    if(_rooms)
        for(Room *room in _rooms)
            [room draw];
    
    if(_curtains)
        for (Curtain *curtain in _curtains)
            [curtain draw];
    
    glPopMatrix();
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    if(_userInteractionEnabled){
//        if(_curtains)
//            for(Curtain *curtain in _curtains)
//                [curtain touchesBegan:touches withEvent:event];
//    }
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    if(_userInteractionEnabled){
//        if(_curtains)
//            for(Curtain *curtain in _curtains)
//                [curtain touchesMoved:touches withEvent:event];
//    }
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    if(_userInteractionEnabled){
//        if(_curtains)
//            for(Curtain *curtain in _curtains)
//                [curtain touchesEnded:touches withEvent:event];
//    }
}

#pragma mark- DELEGATES

// animate transition delegates from SceneController

-(void) transitionFrom:(unsigned short)fromScene To:(unsigned short)toScene Tween:(float)t{
//    NSLog(@"delegate transition:%d-%d, %f",fromScene, toScene, t);
}

// NAVIGATION CONTROLLER

-(void) pageTurnBack:(NSInteger)page{
    [_script gotoScene:page withDuration:1.0];
}

-(void) pageTurnForward:(NSInteger)page{
    [_script gotoScene:page withDuration:1.0];
}


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



#pragma mark- BACK END

// STARTUP

-(void) setup{
    NSLog(@"Stage.m : setup");
    start = [NSDate date];
    _userInteractionEnabled = true;
    orientToDevice = true;
    _backgroundColor = malloc(sizeof(float)*4);
    _script = [[SceneController alloc] init];
    [_script setDelegate:self];
    [self initDeviceOrientation];
}

// OMG cannot subclass viewDidLoad now, cause this is important
-(void)viewDidLoad{
    NSLog(@"Stage.m : viewDidLoad");
    [super viewDidLoad];
    
    // SETUP GLKVIEW
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    self.preferredFramesPerSecond = 60;
    
    [self initOpenGL];
    [self customizeOpenGL];
    
    SWRevealViewController *revealController = [self revealViewController];
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [menuButton setFrame:CGRectMake(10, 10, 44, 44)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"reveal-icon.png"] forState:UIControlStateNormal];
    [menuButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
//TODO: FIX
    NSLog(@"THIS IS A SILLY FIX FOR A BIG PROBLEM");
    [self performSelector:@selector(waitASecond:) withObject:menuButton afterDelay:1.5];
}
-(void) waitASecond:(UIButton*)menuButton{
    SWRevealViewController *revealController = [self revealViewController];
    [menuButton addGestureRecognizer:revealController.panGestureRecognizer];
}

-(void)initOpenGL{
    NSLog(@"Stage.m : initOpenGL");
    
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

-(void) addCurtain:(Curtain *)curtain{
    if(!_curtains) _curtains = [NSArray array];
    _curtains = [_curtains arrayByAddingObject:curtain];
    [self.view addSubview:curtain.view];
}

-(void) bringCurtainToFront:(Curtain*)curtain{
    NSMutableArray *array = [NSMutableArray array];
    for(Curtain *c in _curtains)
        if(![c isEqual:curtain])
            [array addObject:c];
    [array addObject:curtain];
    [self.view bringSubviewToFront:curtain.view];
}

-(void) addRoom:(Room *)room{
    if(!_rooms) _rooms = [NSArray array];
    _rooms = [_rooms arrayByAddingObject:room];
}

-(void) removeCurtains:(NSSet *)objects{
    NSMutableArray *array = [NSMutableArray arrayWithArray:_curtains];
    for(Curtain *curtain in objects){
        if([array containsObject:curtain]){
            [array removeObject:curtain];
        }
    }
    _curtains = [NSArray arrayWithArray:array];
}

-(void) removeRooms:(NSSet *)objects{
    NSMutableArray *array = [NSMutableArray arrayWithArray:_rooms];
    for(Room *room in objects){
        if([array containsObject:room]){
            [array removeObject:room];
        }
    }
    _rooms = [NSArray arrayWithArray:array];
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
    NSLog(@"Stage.m : DEALLOC");
//    free(_screenColor);
}

@end
