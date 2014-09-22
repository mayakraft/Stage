<<<<<<< HEAD
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
=======
#import <OpenGLES/ES1/gl.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Room.h"
#import "Curtain.h"
#import "common.c"
#import "SceneController.h"
//#import "lights.c"

#import "NavBar.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

// ----- IMPORTANT -----
//
// do not subclass viewDidLoad
// if your curtain has a protocol, make sure you manually set the delegate
//

@interface Stage : GLKViewController <SceneTransitionDelegate, NavBarDelegate>//<AnimationDelegate>

@property SceneController *script;

@property (nonatomic) NSArray *rooms;     // ROOMS   (3D ENVIRONMENTS)
@property (nonatomic) NSArray *curtains;  // SCREENS (ORTHOGRAPHIC LAYERS)

-(void) addRoom:(Room*)room;
-(void) addCurtain:(Curtain*)curtain;
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580

@property (nonatomic) float *backgroundColor; // CLEAR SCREEN COLOR

-(void) update;     // automatically called before glkView:drawInRect
-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect;

<<<<<<< HEAD

=======
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580
@end
