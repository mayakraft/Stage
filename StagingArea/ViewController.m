#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

#import "Stage.h"
#import "Rhombicuboctahedron.h"

@interface ViewController (){
    
    EAGLContext     *context;
    GLKBaseEffect   *effect;
    Stage           *stage;
    CMMotionManager *motionManager;
    GLfloat         _attitudeMatrix[16];
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:context];
    GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setView:view];
    view.context = context;
    
    // iOS environment
    float width, height;
    if([UIApplication sharedApplication].statusBarOrientation > 2){
        width = [[UIScreen mainScreen] bounds].size.height;
        height = [[UIScreen mainScreen] bounds].size.width;
    } else{
        width = [[UIScreen mainScreen] bounds].size.width;
        height = [[UIScreen mainScreen] bounds].size.height;
    }

    // init stage
    stage = [[Stage alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self initDeviceOrientation];
    [stage setDeviceAttitude:_attitudeMatrix];
    [stage setOrientToDevice:YES];
}
-(void) initDeviceOrientation{
    motionManager = [[CMMotionManager alloc] init];
    if([motionManager isDeviceMotionAvailable]){
        motionManager.deviceMotionUpdateInterval = 1.0f/60.0f;
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
            CMRotationMatrix a = deviceMotion.attitude.rotationMatrix;
            // matrix has 2 built-in 90 rotations, and reflection across the Z to inverted texture
            _attitudeMatrix[0] = -a.m12;   _attitudeMatrix[1] = -a.m22;  _attitudeMatrix[2] = -a.m32;  _attitudeMatrix[3] = 0.0f;
            _attitudeMatrix[4] = a.m13;    _attitudeMatrix[5] = a.m23;   _attitudeMatrix[6] = a.m33;   _attitudeMatrix[7] = 0.0f;
            _attitudeMatrix[8] = a.m11;    _attitudeMatrix[9] = a.m21;   _attitudeMatrix[10] = a.m31;  _attitudeMatrix[11] = 0.0f;
            _attitudeMatrix[12] = 0.0f;    _attitudeMatrix[13] = 0.0f;   _attitudeMatrix[14] = 0.0f;   _attitudeMatrix[15] = 1.0f;
        
//                _lookVector = GLKVector3Make(-_attitudeMatrix.m02,
//                                             -_attitudeMatrix.m12,
//                                             -_attitudeMatrix.m22);
//                _lookAzimuth = -atan2f(-_lookVector.z, -_lookVector.x);
//                _lookAltitude = asinf(_lookVector.y);
        }];
    }
    else{
        _attitudeMatrix[0] = 1.0f;   _attitudeMatrix[1] = 0.0f;  _attitudeMatrix[2] = 0.0f;  _attitudeMatrix[3] = 0.0f;
        _attitudeMatrix[4] = 0.0f;    _attitudeMatrix[5] = 1.0f;   _attitudeMatrix[6] = 0.0f;   _attitudeMatrix[7] = 0.0f;
        _attitudeMatrix[8] = 0.0f;    _attitudeMatrix[9] = 0.0f;   _attitudeMatrix[10] = 1.0f;  _attitudeMatrix[11] = 0.0f;
        _attitudeMatrix[12] = 0.0f;    _attitudeMatrix[13] = 0.0f;   _attitudeMatrix[14] = 0.0f;   _attitudeMatrix[15] = 1.0f;
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [stage draw];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [stage touchesBegan];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [stage touchesMoved];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [stage touchesEnded];
}

- (void)tearDownGL{
    [stage tearDownGL];
    [EAGLContext setCurrentContext:nil];
    effect = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
