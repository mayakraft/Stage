#import <Foundation/Foundation.h>

@class Animation;
@class Stage;

@protocol AnimationDelegate <NSObject>

-(void) animationDidStop:(Animation*)a;

@end

@interface Animation : NSObject

@property id <AnimationDelegate> delegate;

@property NSTimeInterval startTime;
@property NSTimeInterval endTime;
@property NSTimeInterval duration;

@property float scale;  // 0.0 to 1.0, start to end

-(id)initOnStage:(Stage*)stage Start:(NSTimeInterval)start End:(NSTimeInterval)end;
-(id)initOnStage:(Stage*)stage StartNowWithDuration:(NSTimeInterval)duration;

-(void) animateFrame;
-(id) step;

@end
