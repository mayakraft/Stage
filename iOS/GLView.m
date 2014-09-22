//
//  GLView.m
//  Stage
//
//  Created by Robby on 9/19/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "GLView.h"

@interface GLView (){
    float _aspectRatio;
    float width, height;
}
@end

@implementation GLView

//TODO: compensate for device-orientation aspect

-(id) init{
    return [self initWithFrame:[[UIScreen mainScreen] bounds]];
}

//-(id) initWithFrame:(CGRect)frame context:(EAGLContext *)context{
//    self = [super initWithFrame:frame context:context];
//    if(self){
////        self.frame = frame;
////        _bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        width = self.frame.size.width;
//        height = self.frame.size.height;
//        _aspectRatio = self.frame.size.width/self.frame.size.height;
////        self.opaque = NO;
////        self.backgroundColor = [UIColor clearColor];
//        [self setup];
//    }
//    return self;
//}

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        width = self.frame.size.width;
        height = self.frame.size.height;
        _aspectRatio = self.frame.size.width/self.frame.size.height;
//        self.opaque = NO;
        [self setup];
    }
    return self;
}

-(void) setX:(float)x{
    _x = x;
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

-(void) setY:(float)y{
    _y = y;
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

//-(void) displayLayer:(CALayer *)layer{
//    NSLog(@"display layer");
//    [super displayLayer:layer];
//}

-(void) drawRect:(CGRect)rect{
    NSLog(@"draw rect");
    [super drawRect:rect];
    [self draw];
}

-(void) draw{
    if(!_hidden){
        [self enterOrthographic];
        glTranslatef(_x, _y, 0.0);
        [self content];
        [self exitOrthographic];
    }
}

-(void)content{
    static int rot;
    rot++;
    NSLog(@"draw");
    // implement this function
    // in your subclass
    glColor4f(1.0f, 1.0f, 1.0f, 1.0);
    glTranslatef(self.bounds.size.width*.5, self.bounds.size.height*.5, 0.0);
    glRotatef(rot, 0, 0, 1);
    glScalef(75, 75, 1);
    [self drawPentagon];
}

-(void) drawRect:(CGRect)rect forViewPrintFormatter:(UIViewPrintFormatter *)formatter{
    NSLog(@"draw rect forviewprintformatter");
    [super drawRect:rect forViewPrintFormatter:formatter];
}

-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    NSLog(@"draw layer in context");
    [super drawLayer:layer inContext:ctx];
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

-(void) setup{
    self.backgroundColor = [UIColor clearColor];
    // implement this function
    // in your subclass
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [b setBackgroundColor:[UIColor purpleColor]];
    [self addSubview:b];
}

-(void)enterOrthographic{
    NSLog(@"enter ortho");
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    
    glOrthof(0, [[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.height, -5, 1);
//    glOrthof(0, width, 0, height, -5, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
}

-(void)exitOrthographic{
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

@end