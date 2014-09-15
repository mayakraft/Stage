//
//  CurtainView.m
//  Stage
//
//  Created by Robby on 9/15/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "CurtainView.h"

@implementation CurtainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"hitTest");
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
