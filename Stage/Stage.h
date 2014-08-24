#import <OpenGLES/ES1/gl.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Room.h"
#import "Curtain.h"
#import "NavBar.h"
#import "common.c"
#import "SceneController.h"
//#import "lights.c"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))


@interface Stage : GLKViewController <SceneTransitionDelegate, NavBarDelegate>//<AnimationDelegate>

@property (nonatomic) NSArray *rooms;     // ROOMS   (3D ENVIRONMENTS)
@property (nonatomic) NSArray *curtains;  // SCREENS (ORTHOGRAPHIC LAYERS)

@property SceneController *script;

@property NSArray *tempArray;

//@property Temp *temp;

-(void) addRoom:(Room*)room;
-(void) addCurtain:(Curtain*)curtain;

@property (nonatomic) float *backgroundColor; // CLEAR SCREEN COLOR

-(void) update;     // automatically called before glkView:drawInRect
-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect;

@end
