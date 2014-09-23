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

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _unMovableOrigin = CGPointMake(frame.origin.x, frame.origin.y);
    }
    return self;
}

-(void) setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    _unMovableOrigin = CGPointMake(frame.origin.x, frame.origin.y);
}

-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return self;
}

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
//    [self setCenter:CGPointMake(self.frame.origin.x + self.frame.size.width*.5 - scrollOffset.x,
//                                self.frame.origin.y + self.frame.size.height*.5 - scrollOffset.y)];
    [self setCenter:CGPointMake(_unMovableOrigin.x + self.frame.size.width*.5 - scrollOffset.x,
                                _unMovableOrigin.y + self.frame.size.height*.5 - scrollOffset.y)];
}

-(void) customDraw{
    glPushMatrix();
    glTranslatef(-self.scrollOffset.x, -self.scrollOffset.y, 0.0f);
    
    // draw code here
    
    glPopMatrix();
}

@end
