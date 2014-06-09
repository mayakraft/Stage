#import <Foundation/Foundation.h>
#import "Stage.h"

//typedef NS_OPTIONS(NSUInteger, HotspotScene) {
//    scene1 = 1 << 0,
//    scene2 = 1 << 1,
//    scene3 = 1 << 2,
//};


@interface Hotspot : NSObject

@property CGRect bounds;
@property Scene scene;
@property NSInteger ID;
//@property function pointer

+ (instancetype)hotspotWithID:(NSInteger)i Bounds:(CGRect)rect;

+ (instancetype)hotspotWithID:(NSInteger)i Scene:(Scene)validScenes Bounds:(CGRect)rect;  //TODO: valid scene should be array

@end
