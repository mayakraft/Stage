#import "SceneController.h"

@interface SceneController (){
    unsigned short fromScene;  // during transition
    unsigned short toScene;    //       "
    NSTimeInterval transitionDuration;
    NSTimer *transitionTimer;
    NSDate *start;
}
@end

@implementation SceneController

-(void) update {
    float t = -[start timeIntervalSinceNow];
    if(t >= transitionDuration){
        t = transitionDuration;
        [transitionTimer invalidate];
        transitionTimer = nil;
        _sceneInTransition = false;
        [_delegate endTransitionFrom:fromScene To:toScene];
    }
    [_delegate transitionFrom:fromScene To:toScene Tween:t/transitionDuration];
}

-(void) gotoScene:(unsigned short)scene{
    [_delegate beginTransitionFrom:_scene To:scene];
    [_delegate transitionFrom:_scene To:scene Tween:1.0];
    [_delegate endTransitionFrom:_scene To:scene];
    _scene = scene;
}

-(void) gotoScene:(unsigned short)scene withDuration:(NSTimeInterval)interval{
    _sceneInTransition = true;
    fromScene = _scene;
    toScene = scene;
    transitionDuration = interval;
    
    if(transitionTimer){
        [transitionTimer invalidate];
        transitionTimer = nil;
    }
    [_delegate beginTransitionFrom:fromScene To:toScene];
    transitionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
    start = [NSDate date];
    
    _scene = scene;
}

@end
