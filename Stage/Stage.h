#import <OpenGLES/ES1/gl.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Room.h"
#import "Curtain.h"
#import "NavBar.h"
#import "common.c"
//#import "lights.c"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))


@interface Stage : GLKViewController <NavBarDelegate>//<AnimationDelegate>

@property (nonatomic) NSArray *rooms;
@property (nonatomic) NSArray *curtains;

-(void) addRoom:(Room*)room;            // ROOMS   (3D ENVIRONMENTS)
-(void) addCurtain:(Curtain*)curtain;   // SCREENS (ORTHOGRAPHIC LAYERS)

@property (nonatomic) float *backgroundColor; // CLEAR SCREEN COLOR

-(void) update;     // automatically called before glkView:drawInRect
-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect;

@end
