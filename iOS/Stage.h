//
//  GameViewController.h
//  Stage
//
//  Created by Robby on 9/19/14.
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "Room.h"
#import "ScreenView.h"
//#import "common.c"
#import "AnimationController.h"
#import "GLView.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

@interface Stage : GLKViewController <UIScrollViewDelegate, AnimationDelegate>

@property AnimationController *scene;

@property (nonatomic) NSArray *rooms;     // ROOMS   (3D ENVIRONMENTS)
@property (nonatomic) NSArray *screenViews;  // SCREENS (ORTHOGRAPHIC LAYERS)

-(void) addSubroom:(Room*)roomView;
-(void) addSubglview:(GLView*)glView;
//-(void) addSubscreen:(ScreenView*)screenView;

@property (readonly)  NSTimeInterval elapsedSeconds;

@property (nonatomic) GLKQuaternion  deviceAttitude;
@property (nonatomic) GLKQuaternion  orientation;

@property (nonatomic) float *backgroundColor; // CLEAR SCREEN COLOR

-(void) update;     // automatically called before glkView:drawInRect
-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect;


@end
