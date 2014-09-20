#import <OpenGLES/ES1/gl.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>
#import "RoomView.h"
#import "ScreenView.h"
#import "common.c"
#import "SceneController.h"
//#import "lights.c"

#import "NavBar.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

// ----- IMPORTANT -----
//
// do not subclass
// if your curtain has a protocol, make sure you manually set the delegate
//

@interface Stage : GLKViewController <SceneTransitionDelegate, NavBarDelegate, UIScrollViewDelegate>//<AnimationDelegate>

@property SceneController *script;

@property (nonatomic) NSArray *roomViews;     // ROOMS   (3D ENVIRONMENTS)
@property (nonatomic) NSArray *screenViews;  // SCREENS (ORTHOGRAPHIC LAYERS)

-(void) addSubroom:(RoomView*)roomView;
-(void) addSubscreen:(ScreenView*)screenView;

@property (readonly)  NSTimeInterval elapsedSeconds;
//@property (nonatomic) GLKQuaternion  deviceAttitude;
@property (nonatomic) GLKQuaternion  orientation;      // WORLD ORIENTATION, can depend or not on device attitude
@property (nonatomic) GLKMatrix4     deviceAttitude;

@property (nonatomic) float *backgroundColor; // CLEAR SCREEN COLOR

-(void) update;     // automatically called before glkView:drawInRect
-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect;

@end
