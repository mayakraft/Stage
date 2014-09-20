#import <Foundation/Foundation.h>

@interface RoomView : NSObject

+(instancetype) roomView;  // must subclass and implement with your custom class name

-(void) setup;  // implement these
-(void) draw;   // in your subclass

@end
