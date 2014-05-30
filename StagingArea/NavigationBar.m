//
//  NavigationBar.m
//  StagingArea
//
//  Created by Robby on 5/17/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#import "NavigationBar.h"
#import <OpenGLES/ES1/gl.h>

@interface NavigationBar ()
{
//    static float arrowWidth = ;   // fix this, put make it static
}
@end

@implementation NavigationBar

#define arrowWidth self.frame.size.width*.125

-(void) customDraw{
    glDisable(GL_LIGHTING);

    if(*_scenePointer == 1)
        glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
    else
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    // navigation bar side arrow boxes
    [self drawRect:CGRectMake(arrowWidth*.5+5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth, arrowWidth)];
    [self drawRect:CGRectMake(self.frame.size.width-(arrowWidth*.5)-5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth, arrowWidth)];
    if(*_scenePointer == 1)
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    else
        glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
    // navigation bar plus and minus signs
    [self drawRect:CGRectMake(arrowWidth*.5+5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth*.5, 5)];
    [self drawRect:CGRectMake(self.frame.size.width-(arrowWidth*.5)-5, self.frame.size.height-(arrowWidth*.5)-5, 5, arrowWidth*.5)];
    [self drawRect:CGRectMake(self.frame.size.width-(arrowWidth*.5)-5, self.frame.size.height-(arrowWidth*.5)-5, arrowWidth*.5, 5)];

// a line loop, 2 pixel wide square sides, 10.0 line width makes a crosshair
//    glLineWidth(10.0);
//    glTranslatef(height*.5, width*.5, 0.0);
//    glScalef(1/_aspectRatio, _aspectRatio, 1);
    
//    glLineWidth(10.0);
//    [self drawRectOutline:CGRectMake(width*.5, height*.5, width*.99, height*.99)];

    if(*_scenePointer == 1)
        glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
    else
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    if(*_scenePointer != 3)
        [self drawRect:CGRectMake(self.frame.size.width*.5, arrowWidth, self.frame.size.width, arrowWidth*2)];

    if(*_scenePointer == 1)
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    else
        glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
        
    if(*_scenePointer != 3){
        [self drawRect:CGRectMake(self.frame.size.width*.5, arrowWidth*1.25, self.frame.size.width*4/6., 4)];
        for(int i = 0; i < 9; i++)
            [self drawRect:CGRectMake((self.frame.size.width)/12.*(i+2), arrowWidth*1.25, 1, arrowWidth*.33)];
        [self drawRect:CGRectMake((self.frame.size.width)/12.*(_radioBarPosition+2), arrowWidth*1.25, 20, 20) WithRotation:45];
    }
}


@end
