//
//  ViewController.m
//  StagingArea
//
//  Created by Robby Kraft on 3/26/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    GLfloat fieldOfView;
    GLfloat aspectRatio;
    float backgroundColor;
    EAGLContext *context;
    GLKBaseEffect *effect;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
    [self initGL];
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    backgroundColor = 0.0;
}
-(void)draw3DGraphs{
    static int playBack;
    static int screenRotate;
    
    if(screenRotate % 2 == 0) playBack++;
    
    static const GLfloat XAxis[] = {-1.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f};
    static const GLfloat YAxis[] = {0.0f, -1.0f, 0.0f, 0.0f, 1.0f, 0.0f};
    static const GLfloat ZAxis[] = {0.0f, 0.0f, -1.0f, 0.0f, 0.0f, 1.0f};
    //                   bottom left   top left   top right   bottom right
    //    GLfloat vertices[] = {-1, -1, 0,   -1, 1, 0,   1, 1, 0,   1, -1, 0};
    //    GLubyte indices[] = {0,1,2,  0,2,3};
    
    glPushMatrix();
    
    glTranslatef(0.0, 0.0, -2.0);
    glRotatef(10.0, 1.0, 0.0, 0.0);
    glRotatef(screenRotate/2.0, 0.0, 1.0, 0.0);
    
    //    bool isInvertible;
    //    GLKMatrix4 inverse = GLKMatrix4Invert(_attitudeMatrix, &isInvertible);
    
    glLineWidth(1.0);
    glColor4f(0.5, 0.5, 1.0, 1.0);
    glVertexPointer(3, GL_FLOAT, 0, XAxis);
    //    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_LINE_LOOP, 0, 2);
    glVertexPointer(3, GL_FLOAT, 0, YAxis);
    //    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_LINE_LOOP, 0, 2);
    glVertexPointer(3, GL_FLOAT, 0, ZAxis);
    //    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_LINE_LOOP, 0, 2);
    
    glPopMatrix();
    
    // bottom graphs
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if(0){
        [self enterOrthographic];
        
        glPushMatrix();
        
        glEnableClientState(GL_VERTEX_ARRAY);
        glScalef(screenSize.width/aspectRatio, 5, 1);
        glColor4f(1.0, 0.0, 0.0, 0.5);
//        glVertexPointer(2, GL_FLOAT, 0, accelMagnitude);
//        glDrawArrays(GL_TRIANGLE_STRIP, 0, (recordIndex)*2);
        glDisableClientState(GL_VERTEX_ARRAY);
        
        glColor4f(1.0, 0.0, 0.0, 1.0);
//        GLfloat timeVector[] = {accelMagnitude[4*i], accelMagnitude[4*i+1], accelMagnitude[4*i+2], accelMagnitude[4*i+3]};
//        glVertexPointer(2, GL_FLOAT, 0, timeVector);
        glEnableClientState(GL_VERTEX_ARRAY);
        glDrawArrays(GL_LINE_LOOP, 0, 2);
        
        glPopMatrix();
        
        glPushMatrix();
        
        glEnableClientState(GL_VERTEX_ARRAY);
        glTranslatef(0.0,screenSize.height*aspectRatio, 0);
        glScalef(screenSize.width/aspectRatio, 5, 1);
        glColor4f(0.0, 0.0, 1.0, 0.5);
//        glVertexPointer(2, GL_FLOAT, 0, rotationMagnitude);
//        glDrawArrays(GL_TRIANGLE_STRIP, 0, (recordIndex)*2);
        glDisableClientState(GL_VERTEX_ARRAY);
        
        glColor4f(0.0, 0.0, 1.0, 1.0);
//        GLfloat timeVector2[] = {rotationMagnitude[4*i], rotationMagnitude[4*i+1], rotationMagnitude[4*i+2], rotationMagnitude[4*i+3]};
//        glVertexPointer(2, GL_FLOAT, 0, timeVector2);
        glEnableClientState(GL_VERTEX_ARRAY);
        glDrawArrays(GL_LINE_LOOP, 0, 2);
        
        glPopMatrix();
        
        [self exitOrthographic];
    }
    screenRotate++;
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(backgroundColor, backgroundColor, backgroundColor, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glMatrixMode(GL_MODELVIEW);
    if(!backgroundColor){
        if(0){
//            [self drawHexagons];
        }
        else{
            [self draw3DGraphs];
        }
    }
}

-(void)initGL{
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    [EAGLContext setCurrentContext:context];
    
    fieldOfView = 75;
    aspectRatio = (float)[[UIScreen mainScreen] bounds].size.width / (float)[[UIScreen mainScreen] bounds].size.height;
    if([UIApplication sharedApplication].statusBarOrientation > 2)
        aspectRatio = 1/aspectRatio;
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glCullFace(GL_FRONT_AND_BACK);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    float zNear = 0.01;
    float zFar = 1000;
    GLfloat frustum = zNear * tanf(GLKMathDegreesToRadians(fieldOfView) / 2.0);
    glFrustumf(-frustum, frustum, -frustum/aspectRatio, frustum/aspectRatio, zNear, zFar);
    glViewport(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_DEPTH_TEST);
    glLoadIdentity();
}

- (void)tearDownGL{
    [EAGLContext setCurrentContext:context];
    //unload shapes
//    glDeleteBuffers(1, &_vertexBuffer);
//    glDeleteVertexArraysOES(1, &_vertexArray);
    effect = nil;
}


-(void)enterOrthographic{
    glDisable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glOrthof(0, [[UIScreen mainScreen] bounds].size.height, 0, [[UIScreen mainScreen] bounds].size.width, -5, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
}

-(void)exitOrthographic{
    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
