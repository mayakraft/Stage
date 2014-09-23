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

-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"GLView (%d): hitTest:(%.1f,%.1f) Subviews:%d",self.tag, point.x, point.y, self.subviews.count);
    for(UIView* v in [self subviews]){
        CGPoint touchPoint = [v convertPoint:point fromView:self];
        if(v.userInteractionEnabled && [v pointInside:touchPoint withEvent:event]){
            NSLog(@"Point Inside: %@",v.description);
            return [super hitTest:point withEvent:event];
        }
    }
    if([self isKindOfClass:[GLView class]])
        return nil;
    return [super hitTest:point withEvent:event];
}


//TODO: compensate for device-orientation aspect

-(id) init{
    return [self initWithFrame:[[UIScreen mainScreen] bounds]];
}

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        width = self.frame.size.width;
        height = self.frame.size.height;
        _aspectRatio = self.frame.size.width/self.frame.size.height;
        self.backgroundColor = [UIColor clearColor];
//        self.opaque = NO;
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

-(void)content{  }

-(void) drawRect:(CGRect)rect forViewPrintFormatter:(UIViewPrintFormatter *)formatter{
    NSLog(@"draw rect forviewprintformatter");
    [super drawRect:rect forViewPrintFormatter:formatter];
}

-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    NSLog(@"draw layer in context");
    [super drawLayer:layer inContext:ctx];
}

-(void)enterOrthographic{
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glOrthof(0, width, 0, height, -5, 1);
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