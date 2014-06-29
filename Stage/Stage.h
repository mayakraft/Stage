#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>
#include "common.c"
#import "Room.h"
#import "Flat.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))


@interface Stage : GLKViewController //<AnimationDelegate>

@property (nonatomic) Room *room;         // ROOMS   (3D ENVIRONMENTS)
@property (nonatomic) Flat *flat;         // SCREENS (ORTHOGRAPHIC LAYERS)

+(instancetype) StageWithNavBar:(Flat*)navBar;

-(void) update;
-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect;

@end
