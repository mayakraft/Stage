#import "Hotspot.h"

@implementation Hotspot

+(instancetype)hotspotWithID:(NSInteger)i Bounds:(CGRect)rect{
    Hotspot *h = [[Hotspot alloc] init];
    if(h){
        [h setBounds:rect];
        [h setID:i];
    }
    return h;
}
@end
