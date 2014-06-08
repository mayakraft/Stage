#import <Foundation/Foundation.h>

@interface FlatPrimitives : NSObject

/* 2D PRIMITIVES */

-(void) drawRect:(CGRect)rect;
-(void) drawRectOutline:(CGRect)rect;
-(void) drawHexagons;
-(void) drawHexLines;

-(void) drawRect:(CGRect)rect WithRotation:(float)degrees;

@end
