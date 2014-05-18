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

@end

@implementation NavigationBar

-(void) customDraw{

    static GLfloat whiteColor[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    static GLfloat clearColor[4] = {1.0f, 1.0f, 1.0f, 0.3f};
    glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, whiteColor);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, whiteColor);
    
// a line loop, 2 pixel wide square sides, 10.0 line width makes a crosshair
//    glLineWidth(10.0);
//    glTranslatef(height*.5, width*.5, 0.0);
//    glScalef(1/_aspectRatio, _aspectRatio, 1);
    
//    glLineWidth(10.0);
//    [self drawRectOutline:CGRectMake(width*.5, height*.5, width*.99, height*.99)];
    
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, clearColor);
    [self drawRect:CGRectMake(self.frame.size.width*.5, 40, self.frame.size.width, 80)];
    
    [self drawRect:CGRectMake(25, self.frame.size.height-25, 40, 40)];
    [self drawRect:CGRectMake(self.frame.size.width-25, self.frame.size.height-25, 40, 40)];
}


@end
