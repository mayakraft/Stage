#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Stage : GLKView

-(void) setup;

-(void) draw;

-(void) tearDownGL;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@property CGRect frame;

@property BOOL orientToDevice;

@property GLfloat *deviceAttitude;  // pointer to data coming from ViewController's CMMotionManager
@property GLKMatrix4 orientationMatrix;

@end
