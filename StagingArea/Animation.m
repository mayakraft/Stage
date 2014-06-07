#import "Animation.h"
#import "Stage.h"

@implementation Animation

-(id)initOnStage:(Stage*)stage Start:(NSTimeInterval)start End:(NSTimeInterval)end {
    self = [super init];
    if (self) {
        _startTime = start;
        _endTime = end;
        _duration = end-start;
        _delegate = stage;
    }
    return self;
}

-(id)initOnStage:(Stage*)stage StartNowWithDuration:(NSTimeInterval)duration{
    self = [super init];
    if (self) {
        _startTime = [(Stage*)_delegate elapsedSeconds];
        _endTime = _startTime+duration;
        _duration = duration;
        _delegate = stage;
    }
    return self;
}

-(void) animateFrame{
//    NSLog(@"%.2f < %.2f < %.2f", _startTime, elapsedSeconds, _endTime);
    
}

-(id) step{
    if(_endTime < [(Stage*)_delegate elapsedSeconds]){
        [_delegate animationDidStop:self];
        return nil;
    }
    _scale = ([(Stage*)_delegate elapsedSeconds] - _startTime)/_duration;
    return self;
}

@end



//typedef struct Animation Animation;
//struct Animation{
//    NSTimeInterval startTime;
//    NSTimeInterval endTime;
//    NSTimeInterval duration;
//    void (*animate)(Stage *s, Animation *a, float elapsedSeconds);
//};
//Animation* makeAnimation(NSTimeInterval start, NSTimeInterval end, void (*animationFunction)(Stage *s, Animation *a, float elapsedSeconds)){
//    Animation *a = malloc(sizeof(Animation));
//    a->startTime = start;
//    a->endTime = end;
//    a->duration = end-start;
//    a->animate = animationFunction;
//    return a;
//}
//Animation* makeAnimationWithDuration(NSTimeInterval start, NSTimeInterval duration, void (*animationFunction)(Stage *s, Animation *a, float elapsedSeconds)){
//    Animation *a = malloc(sizeof(Animation));
//    a->startTime = start;
//    a->endTime = start+duration;
//    a->duration = duration;
//    a->animate = animationFunction;
//    return a;
//}
//void logAnimation(Stage *s, Animation *a, float elapsedSeconds){
//    NSLog(@"%.2f < %.2f < %.2f", a->startTime, elapsedSeconds, a->endTime);
//}
