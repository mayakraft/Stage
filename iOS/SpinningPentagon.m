//
//  SpinningPentagon.m
//  Stage
//
//  Created by Robby on 9/22/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "SpinningPentagon.h"

#include "Primitives.h"

@implementation SpinningPentagon

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:NO];
    }
    return self;
}

-(void)content{
    static int rot;
    rot++;
    glColor4f(1.0f, 1.0f, 1.0f, 1.0);
    glTranslatef(self.bounds.size.width*.5, self.bounds.size.height*.5, 0.0);
    glRotatef(rot, 0, 0, 1);
    glScalef(100, 100, 1);
//    glDrawRect(CGRectMake(0, 0, 2, 2));
    glDrawTriangle();
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
