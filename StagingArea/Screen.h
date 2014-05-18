
#import <Foundation/Foundation.h>
#import "Primitives.h"

@interface Screen : Primitives

@property (nonatomic) CGRect frame;

-(id) initWithFrame:(CGRect)frame;
-(void) draw;

@end
