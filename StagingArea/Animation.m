//
//  Animation.m
//  StagingArea
//
//  Created by Robby on 6/2/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#import "Animation.h"

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

-(id)initOnStage:(Stage*)stage Start:(NSTimeInterval)start Duration:(NSTimeInterval)duration{
    self = [super init];
    if (self) {
        _startTime = start;
        _endTime = start+duration;
        _duration = duration;
        _delegate = stage;
    }
    return self;
}

-(float) scale{
    return (_delegate.elapsedSeconds - _startTime)/_duration;
}

-(void) animateFrame{
//    NSLog(@"%.2f < %.2f < %.2f", _startTime, elapsedSeconds, _endTime);
    
}


@end
