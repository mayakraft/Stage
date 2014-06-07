#import <Foundation/Foundation.h>

@interface Primitives : NSObject

/* 2D PRIMITIVES */

-(void) drawRect:(CGRect)rect;
-(void) drawRectOutline:(CGRect)rect;
-(void) drawHexagons;
-(void) drawHexLines;

-(void) drawRect:(CGRect)rect WithRotation:(float)degrees;

@end
