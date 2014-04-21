#import <Foundation/Foundation.h>

@interface Stage : NSObject

-(id) initWithFrame:(CGRect)frame;
-(void) draw;
-(void)tearDownGL;

-(void) touchesEnded;

@property CGRect frame;

-(void)setAttitude:(GLfloat*)attitude;

@end
