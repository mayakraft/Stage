#import <Foundation/Foundation.h>

@interface Stage : NSObject

-(id) init; // init Stage after EAGL context has been setup
-(void) draw;
-(void) loadRandomGeodesic;

@end
