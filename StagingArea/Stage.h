#import <Foundation/Foundation.h>

@interface Stage : NSObject

-(id) initWithFrame:(CGRect)frame;

-(void) draw;

-(void) tearDownGL;

-(void) touchesBegan;
-(void) touchesMoved;
-(void) touchesEnded;

@property CGRect frame;

@property BOOL orientToDevice;

@property GLfloat *deviceAttitude;

@end
