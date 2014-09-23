//
//  SpinningPentagon.m
//  Stage
//
//  Created by Robby on 9/22/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "SpinningPentagon.h"

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

-(void) drawPentagon{
    static const GLfloat pentFan[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        .951f, .309f,
        .5878, -.809,
        -.5878, -.809,
        -.951f, .309f,
        0.0f, 1.0f
    };
    glEnableClientState(GL_VERTEX_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, pentFan);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 7);
    glDisableClientState(GL_VERTEX_ARRAY);
}

-(void)content{
    static int rot;
    rot++;
    glColor4f(1.0f, 1.0f, 1.0f, 1.0);
    glTranslatef(self.bounds.size.width*.5, self.bounds.size.height*.5, 0.0);
    glRotatef(rot, 0, 0, 1);
    glScalef(75, 75, 1);
    [self drawPentagon];
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
