#import <Foundation/Foundation.h>

@interface Stage : NSObject

-(id) initWithFrame:(CGRect)frame;

-(void) draw;

-(void) touchesEnded;

-(void)tearDownGL;

@property CGRect frame;

@end
