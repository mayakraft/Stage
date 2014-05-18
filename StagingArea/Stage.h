#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Stage : GLKView

-(void) setup;

-(void) draw;

-(void) tearDownGL;

-(void) touchesBegan;
-(void) touchesMoved;
-(void) touchesEnded;

@property CGRect frame;

@property BOOL orientToDevice;

@property GLfloat *deviceAttitude;

@end
