#import "RoomView.h"

@implementation RoomView

+(instancetype) roomView{
    RoomView *roomView = [[RoomView alloc] init];
    return roomView;
}

-(id)init{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

-(void) setup{
    // implement this function
    // in your subclass
}

-(void) draw{
    // implement this function
    // in your subclass
}

@end
