#import <Foundation/Foundation.h>

@interface Hotspot : NSObject

@property CGRect bounds;
@property NSInteger ID;
//@property function pointer

+ (instancetype)hotspotWithID:(NSInteger)i Bounds:(CGRect)rect;

@end
