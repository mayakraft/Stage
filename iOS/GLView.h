//
//  GLView.h
//  Stage
//
//  Created by Robby on 9/19/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <GLKit/GLKit.h>

@interface GLView : UIView

@property (nonatomic, readonly) float x;
@property (nonatomic, readonly) float y;

@property (nonatomic) BOOL hidden;

-(id) init;   // default fullscreen
-(id) initWithFrame:(CGRect)frame;

-(void) draw;

@end


