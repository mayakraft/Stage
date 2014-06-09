#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Animation.h"

// # SCENES
typedef enum{
    scene1,
    scene2,
    scene3,
    scene4,
    scene5
} Scene;

// define all possible kinds of transitions:
typedef enum{
    animationNone,
    animationOrthoToPerspective,
    animationPerspectiveToOrtho,
    animationInsideToPerspective,
    animationPerspectiveToInside
} AnimationState;

// give names to all hotspots:
typedef enum{
    hotspotBackArrow,
    hotspotForwardArrow,
    hotspotControls
} HotspotID;

@interface Stage : GLKView <AnimationDelegate>

@property (readonly) NSTimeInterval elapsedSeconds;
@property (nonatomic) Scene          scene;
@property GLfloat        *deviceAttitude;  // pointer to data coming from ViewController's CMMotionManager
@property GLKMatrix4     orientationMatrix;

//@property(nonatomic,getter=isUserInteractionEnabled) BOOL userInteractionEnabled;
//@property (atomic) BOOL userInteractionEnabled;

-(void) setup;
-(void) draw;
-(void) tearDownGL;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
