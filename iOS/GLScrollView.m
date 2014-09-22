//
//  GLScrollView.m
//  Stage
//
//  Created by Robby on 9/17/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "GLScrollView.h"

#define NUMBER_OF_LITTLE_CUBES  20
#define LITTLE_CUBE_WIDTH      (320.f / 3.f)
#define SCROLLER_HEIGHT        LITTLE_CUBE_WIDTH


@implementation GLScrollView

- (CGRect)scrollableFrame
{
    return CGRectMake(0, 30, 320, SCROLLER_HEIGHT);
}

- (CGSize)scrollableContentSize
{
    CGFloat width = NUMBER_OF_LITTLE_CUBES * LITTLE_CUBE_WIDTH;
    return CGSizeMake(ceilf(width), SCROLLER_HEIGHT);
}

- (CGPoint)scrollOffsetForProposedOffset:(CGPoint)offset
{
    CGFloat fractionalPart = fmodf(offset.x, LITTLE_CUBE_WIDTH);
    BOOL roundDown = fractionalPart < (LITTLE_CUBE_WIDTH / 2.f);
    if (roundDown) {
        offset.x -= fractionalPart;
    } else {
        offset.x += (LITTLE_CUBE_WIDTH - fractionalPart);
    }
    
    return offset;
}

-(void) setScrollOffset:(CGPoint)scrollOffset{
    _scrollOffset = scrollOffset;
    [self.view setCenter:CGPointMake(self.frame.origin.x + self.frame.size.width*.5 - scrollOffset.x,
                                     self.frame.origin.y + self.frame.size.height*.5 - scrollOffset.y)];
}

-(void) customDraw{
    glPushMatrix();
    glTranslatef(- self.scrollOffset.x, -self.scrollOffset.y, 0.0f);
    
    // draw code here
    
    glPopMatrix();
}

@end
