//
//  ViewController.m
//  StagingArea
//
//  Created by Robby Kraft on 3/26/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#import "ViewController.h"
#import "Stage.h"


@interface ViewController (){
    EAGLContext *context;
    GLKBaseEffect *effect;
    
    Stage *stage;
}
@end

//
//
//  to do
//
//  make:
//    obj -> openGL file
//    openGL -> obj file
//
//

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:context];
    GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setView:view];
    view.context = context;
    
    stage = [[Stage alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tap];
}

-(void) tapHandler:(UIGestureRecognizer*)sender{
    [stage loadRandomGeodesic];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [stage draw];
}

- (void)tearDownGL{
    [EAGLContext setCurrentContext:context];
    //unload shapes
//    glDeleteBuffers(1, &_vertexBuffer);
//    glDeleteVertexArraysOES(1, &_vertexArray);
    effect = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
