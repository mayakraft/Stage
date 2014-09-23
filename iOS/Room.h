#import <Foundation/Foundation.h>

@interface Room : NSObject

+(instancetype) room;  // must subclass and implement with your custom class name

-(void) draw;   // implement in your subclass

@end
